package com.mycompany.water_tracker.widget

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.content.Intent
import android.graphics.Bitmap
import android.graphics.Canvas
import android.graphics.Color
import android.graphics.LinearGradient
import android.graphics.Paint
import android.graphics.Path
import android.graphics.RectF
import android.graphics.Shader
import android.graphics.Typeface
import android.net.Uri
import android.os.Build
import android.os.Bundle
import android.widget.RemoteViews
import com.mycompany.water_tracker.R
import es.antonborri.home_widget.HomeWidgetBackgroundReceiver
import es.antonborri.home_widget.HomeWidgetPlugin
import java.text.SimpleDateFormat
import java.util.Date
import java.util.Locale

class WaterWidgetReceiver : AppWidgetProvider() {

  private companion object {
    const val HOME_WIDGET_BACKGROUND_ACTION = "es.antonborri.home_widget.action.BACKGROUND"
    const val PRIMARY = "#0288D1"
    const val PRIMARY_LIGHT = "#4FC3F7"
    const val TEXT = "#0E2235"
    const val MUTED = "#5B7184"
  }

  override fun onUpdate(
    context: Context,
    appWidgetManager: AppWidgetManager,
    appWidgetIds: IntArray,
  ) {
    super.onUpdate(context, appWidgetManager, appWidgetIds)
    appWidgetIds.forEach { appWidgetId ->
      updateSingleWidget(context, appWidgetManager, appWidgetId)
    }
  }

  override fun onAppWidgetOptionsChanged(
    context: Context,
    appWidgetManager: AppWidgetManager,
    appWidgetId: Int,
    newOptions: Bundle,
  ) {
    super.onAppWidgetOptionsChanged(context, appWidgetManager, appWidgetId, newOptions)
    updateSingleWidget(context, appWidgetManager, appWidgetId)
  }

  override fun onReceive(context: Context, intent: Intent) {
    super.onReceive(context, intent)
  }

  private fun updateSingleWidget(
    context: Context,
    appWidgetManager: AppWidgetManager,
    appWidgetId: Int,
  ) {
    val prefs = HomeWidgetPlugin.getData(context)
    val current = prefs.getInt("current_ml", 0)
    val goal = prefs.getInt("goal_ml", 2000).coerceAtLeast(1)
    val progress = (current.toFloat() / goal.toFloat()).coerceIn(0f, 1f)
    val percent = (progress * 100).toInt()
    val currentL = String.format(Locale.US, "%.2f", current / 1000f)
    val goalL = String.format(Locale.US, "%.2f", goal / 1000f)
    val layout = chooseLayout(appWidgetManager.getAppWidgetOptions(appWidgetId))

    val views = RemoteViews(context.packageName, layout).apply {
      when (layout) {
        R.layout.water_widget_large_layout -> bindLarge(context, current, goal, progress)
        R.layout.water_widget_compact_layout -> bindCompact(context, currentL, goalL, percent)
        else -> bindMedium(context, currentL, goalL, percent, progress)
      }
    }
    appWidgetManager.updateAppWidget(appWidgetId, views)
  }

  private fun chooseLayout(options: Bundle?): Int {
    val minWidth = options?.getInt(AppWidgetManager.OPTION_APPWIDGET_MIN_WIDTH, 0) ?: 0
    val minHeight = options?.getInt(AppWidgetManager.OPTION_APPWIDGET_MIN_HEIGHT, 0) ?: 0
    return when {
      minHeight >= 280 -> R.layout.water_widget_large_layout
      minWidth <= 210 -> R.layout.water_widget_compact_layout
      else -> R.layout.water_widget_layout
    }
  }

  private fun RemoteViews.bindCompact(
    context: Context,
    currentL: String,
    goalL: String,
    percent: Int,
  ) {
    setTextViewText(R.id.tvPercent, "$percent%")
    setTextViewText(R.id.tvAmount, "$currentL/$goalL л")
    setProgressBar(R.id.pbGoal, 100, percent, false)
    setOnClickPendingIntent(R.id.btnAdd250, addIntent(context, 250))
  }

  private fun RemoteViews.bindMedium(
    context: Context,
    currentL: String,
    goalL: String,
    percent: Int,
    progress: Float,
  ) {
    setTextViewText(R.id.tvTitle, "Сегодня")
    setTextViewText(R.id.tvAmount, currentL)
    setTextViewText(R.id.tvGoal, "/ $goalL л")
    setImageViewBitmap(
      R.id.ivWaterProgress,
      circularWaterBitmap(154f, progress, "$percent%"),
    )
    setOnClickPendingIntent(R.id.btnAdd150, addIntent(context, 150))
    setOnClickPendingIntent(R.id.btnAdd250, addIntent(context, 250))
    setOnClickPendingIntent(R.id.btnAdd500, addIntent(context, 500))
  }

  private fun RemoteViews.bindLarge(
    context: Context,
    current: Int,
    goal: Int,
    progress: Float,
  ) {
    setTextViewText(R.id.tvTitle, "CupOfWater")
    setTextViewText(R.id.tvDate, SimpleDateFormat("d MMMM", Locale("ru")).format(Date()))
    setTextViewText(R.id.tvStreak, "7")
    setImageViewBitmap(
      R.id.ivWaterProgress,
      circularWaterBitmap(
        250f,
        progress,
        formatMl(current),
        "из ${formatMl(goal)} мл",
      ),
    )
    setImageViewBitmap(R.id.ivWeekBars, weekBarsBitmap(progress))
    setOnClickPendingIntent(R.id.btnAdd200, addIntent(context, 200))
    setOnClickPendingIntent(R.id.btnAdd250, addIntent(context, 250))
    setOnClickPendingIntent(R.id.btnAdd500, addIntent(context, 500))
  }

  private fun addIntent(context: Context, ml: Int): PendingIntent {
    val intent = Intent(context, HomeWidgetBackgroundReceiver::class.java).apply {
      action = HOME_WIDGET_BACKGROUND_ACTION
      data = Uri.parse("waterwidget://add?ml=$ml")
    }
    var flags = PendingIntent.FLAG_UPDATE_CURRENT
    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
      flags = flags or PendingIntent.FLAG_IMMUTABLE
    }
    return PendingIntent.getBroadcast(
      context,
      ml,
      intent,
      flags,
    )
  }

  private fun circularWaterBitmap(
    sizeDp: Float,
    progress: Float,
    label: String,
    sublabel: String? = null,
  ): Bitmap {
    val size = sizeDp.toInt()
    fun px(value: Float) = value * size / sizeDp
    val stroke = px(14f)
    val bitmap = Bitmap.createBitmap(size, size, Bitmap.Config.ARGB_8888)
    val canvas = Canvas(bitmap)
    val cx = size / 2f
    val cy = size / 2f
    val radius = (size - stroke) / 2f
    val innerRadius = radius - stroke / 2f - px(4f)
    val primary = Color.parseColor(PRIMARY)
    val light = Color.parseColor(PRIMARY_LIGHT)

    val trackPaint = Paint(Paint.ANTI_ALIAS_FLAG).apply {
      style = Paint.Style.STROKE
      strokeWidth = stroke
      color = Color.argb(31, 2, 136, 209)
    }
    canvas.drawCircle(cx, cy, radius, trackPaint)

    val clip = Path().apply {
      addCircle(cx, cy, innerRadius, Path.Direction.CW)
    }
    val saved = canvas.save()
    canvas.clipPath(clip)
    val waterTop = cy + innerRadius - innerRadius * 2f * progress
    val fillPaint = Paint(Paint.ANTI_ALIAS_FLAG).apply {
      shader = LinearGradient(
        0f,
        waterTop,
        0f,
        size.toFloat(),
        light,
        primary,
        Shader.TileMode.CLAMP,
      )
    }
    canvas.drawRect(0f, waterTop, size.toFloat(), size.toFloat(), fillPaint)
    val wavePaint = Paint(Paint.ANTI_ALIAS_FLAG).apply {
      shader = fillPaint.shader
      alpha = 220
    }
    val wave = Path().apply {
      moveTo(-size.toFloat(), waterTop)
      rQuadTo(size / 4f, -px(10f), size / 2f, 0f)
      rQuadTo(size / 4f, px(10f), size / 2f, 0f)
      rQuadTo(size / 4f, -px(10f), size / 2f, 0f)
      lineTo(size.toFloat(), size.toFloat())
      lineTo(-size.toFloat(), size.toFloat())
      close()
    }
    canvas.drawPath(wave, wavePaint)
    canvas.restoreToCount(saved)

    val arcPaint = Paint(Paint.ANTI_ALIAS_FLAG).apply {
      style = Paint.Style.STROKE
      strokeWidth = stroke
      strokeCap = Paint.Cap.ROUND
      color = primary
    }
    val oval = RectF(cx - radius, cy - radius, cx + radius, cy + radius)
    canvas.drawArc(oval, -90f, progress * 360f, false, arcPaint)

    val rimPaint = Paint(Paint.ANTI_ALIAS_FLAG).apply {
      style = Paint.Style.STROKE
      strokeWidth = px(1f)
      color = Color.argb(153, 255, 255, 255)
    }
    canvas.drawCircle(cx, cy, innerRadius, rimPaint)

    drawCenteredLabel(canvas, cx, cy, label, sublabel)
    return bitmap
  }

  private fun drawCenteredLabel(
    canvas: Canvas,
    cx: Float,
    cy: Float,
    label: String,
    sublabel: String?,
  ) {
    val sizePx = cx * 2f
    val labelPaint = Paint(Paint.ANTI_ALIAS_FLAG).apply {
      color = Color.parseColor(TEXT)
      textAlign = Paint.Align.CENTER
      typeface = Typeface.create(Typeface.DEFAULT, Typeface.BOLD)
      textSize = sizePx * 0.18f
    }
    val labelY = if (sublabel == null) {
      cy - (labelPaint.descent() + labelPaint.ascent()) / 2f
    } else {
      cy - sizePx * 0.024f
    }
    canvas.drawText(label, cx, labelY, labelPaint)

    if (sublabel != null) {
      val subPaint = Paint(Paint.ANTI_ALIAS_FLAG).apply {
        color = Color.parseColor(MUTED)
        textAlign = Paint.Align.CENTER
        typeface = Typeface.create(Typeface.DEFAULT, Typeface.NORMAL)
        textSize = sizePx * 0.055f
      }
      canvas.drawText(sublabel, cx, labelY + sizePx * 0.095f, subPaint)
    }
  }

  private fun weekBarsBitmap(todayProgress: Float): Bitmap {
    val width = 320
    val height = 44
    val bitmap = Bitmap.createBitmap(width, height, Bitmap.Config.ARGB_8888)
    val canvas = Canvas(bitmap)
    val values = floatArrayOf(1f, 0.84f, 1f, 0.76f, 1f, 0.92f, todayProgress)
    val days = arrayOf("П", "В", "С", "Ч", "П", "С", "В")
    val gap = 6f
    val barHeight = 24f
    val barWidth = (width - gap * 6f) / 7f
    val radius = 6f
    val trackPaint = Paint(Paint.ANTI_ALIAS_FLAG).apply {
      color = Color.argb(153, 255, 255, 255)
    }
    val fillPaint = Paint(Paint.ANTI_ALIAS_FLAG)
    val textPaint = Paint(Paint.ANTI_ALIAS_FLAG).apply {
      textAlign = Paint.Align.CENTER
      textSize = 10f
      typeface = Typeface.create(Typeface.DEFAULT, Typeface.NORMAL)
    }

    values.forEachIndexed { index, value ->
      val left = index * (barWidth + gap)
      val top = 0f
      val right = left + barWidth
      val bottom = barHeight
      canvas.drawRoundRect(RectF(left, top, right, bottom), radius, radius, trackPaint)

      fillPaint.color = if (index == values.lastIndex) {
        Color.parseColor(PRIMARY)
      } else {
        Color.argb(128, 2, 136, 209)
      }
      val fillHeight = barHeight * value.coerceIn(0f, 1f)
      canvas.drawRoundRect(
        RectF(left, bottom - fillHeight, right, bottom),
        radius,
        radius,
        fillPaint,
      )

      textPaint.color = if (index == values.lastIndex) {
        Color.parseColor(PRIMARY)
      } else {
        Color.argb(153, 14, 34, 53)
      }
      textPaint.typeface = Typeface.create(
        Typeface.DEFAULT,
        if (index == values.lastIndex) Typeface.BOLD else Typeface.NORMAL,
      )
      canvas.drawText(days[index], left + barWidth / 2f, height - 4f, textPaint)
    }
    return bitmap
  }

  private fun formatMl(value: Int): String {
    return String.format(Locale.US, "%,d", value).replace(',', ' ')
  }
}
