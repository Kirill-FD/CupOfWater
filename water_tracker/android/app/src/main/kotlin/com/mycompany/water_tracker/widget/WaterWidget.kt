package com.mycompany.water_tracker.widget

import android.content.Context
import android.net.Uri
import com.mycompany.water_tracker.MainActivity
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.unit.dp
import androidx.glance.GlanceId
import androidx.glance.GlanceModifier
import androidx.glance.action.clickable
import androidx.glance.appwidget.GlanceAppWidget
import androidx.glance.appwidget.cornerRadius
import androidx.glance.appwidget.provideContent
import androidx.glance.background
import androidx.glance.layout.Alignment
import androidx.glance.layout.Box
import androidx.glance.layout.Column
import androidx.glance.layout.Spacer
import androidx.glance.layout.fillMaxSize
import androidx.glance.layout.fillMaxWidth
import androidx.glance.layout.height
import androidx.glance.layout.padding
import androidx.glance.text.FontWeight
import androidx.glance.text.Text
import androidx.glance.text.TextStyle
import androidx.glance.unit.ColorProvider
import androidx.glance.unit.sp
import es.antonborri.home_widget.HomeWidgetPlugin
import es.antonborri.home_widget.actionStartActivity

class WaterWidget : GlanceAppWidget() {
  override suspend fun provideGlance(context: Context, id: GlanceId) {
    val prefs = HomeWidgetPlugin.getData(context)
    val current = prefs.getInt("current_ml", 0)
    val goal = prefs.getInt("goal_ml", 2000).coerceAtLeast(1)
    val progress = (current.toFloat() / goal.toFloat()).coerceIn(0f, 1f)
    val percent = (progress * 100).toInt()

    provideContent {
      Column(
        modifier = GlanceModifier
          .fillMaxSize()
          .padding(12.dp)
          .background(Color(0xFFFFFFFF))
          .cornerRadius(16.dp),
        verticalAlignment = Alignment.CenterVertically,
        horizontalAlignment = Alignment.CenterHorizontally
      ) {
        Text(
          "💧 Вода",
          style = TextStyle(
            fontSize = 14.sp,
            fontWeight = FontWeight.Medium,
            color = ColorProvider(Color(0xFF0288D1))
          )
        )
        Spacer(GlanceModifier.height(4.dp))
        Text(
          "$current / $goal мл",
          style = TextStyle(
            fontSize = 18.sp,
            fontWeight = FontWeight.Bold,
            color = ColorProvider(Color(0xFF0A1929))
          )
        )
        Spacer(GlanceModifier.height(4.dp))
        Text(
          "$percent%",
          style = TextStyle(
            fontSize = 22.sp,
            fontWeight = FontWeight.Bold,
            color = ColorProvider(Color(0xFF0288D1))
          )
        )
        Spacer(GlanceModifier.height(10.dp))
        Box(
          modifier = GlanceModifier
            .fillMaxWidth()
            .height(36.dp)
            .background(Color(0xFF0288D1))
            .cornerRadius(12.dp)
            .clickable(
              onClick = actionStartActivity<MainActivity>(
                context = context,
                uri = Uri.parse("waterwidget://add?ml=250")
              )
            ),
          contentAlignment = Alignment.Center
        ) {
          Text(
            "+ 250 мл",
            style = TextStyle(
              fontSize = 14.sp,
              fontWeight = FontWeight.Bold,
              color = ColorProvider(Color.White)
            )
          )
        }
      }
    }
  }
}
