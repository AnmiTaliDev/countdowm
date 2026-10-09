package dev.anmitali.countdown

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.Intent
import android.content.SharedPreferences
import android.view.View
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetProvider

class CountdownWidgetProvider : HomeWidgetProvider() {
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
        widgetData: SharedPreferences,
    ) {
        val name = widgetData.getString("next_name", null)
        val cost = widgetData.getString("next_cost", null)
        val chargeMillis = widgetData.getString("next_charge_millis", null)?.toLongOrNull()

        val openApp = PendingIntent.getActivity(
            context,
            0,
            Intent(context, MainActivity::class.java),
            PendingIntent.FLAG_IMMUTABLE or PendingIntent.FLAG_UPDATE_CURRENT,
        )

        for (id in appWidgetIds) {
            val views = RemoteViews(context.packageName, R.layout.countdown_widget)
            views.setOnClickPendingIntent(R.id.widget_root, openApp)
            if (name == null || cost == null || chargeMillis == null) {
                views.setTextViewText(R.id.widget_name, context.getString(R.string.widget_empty))
                views.setViewVisibility(R.id.widget_countdown, View.GONE)
                views.setViewVisibility(R.id.widget_cost, View.GONE)
            } else {
                views.setTextViewText(R.id.widget_name, name)
                views.setTextViewText(R.id.widget_countdown, countdownText(context, chargeMillis))
                views.setTextViewText(R.id.widget_cost, cost)
                views.setViewVisibility(R.id.widget_countdown, View.VISIBLE)
                views.setViewVisibility(R.id.widget_cost, View.VISIBLE)
            }
            appWidgetManager.updateAppWidget(id, views)
        }
    }

    private fun countdownText(context: Context, chargeMillis: Long): String {
        val remaining = chargeMillis - System.currentTimeMillis()
        if (remaining <= 0) {
            return context.getString(R.string.widget_today)
        }
        val hoursTotal = remaining / 3_600_000
        return context.getString(R.string.widget_remaining, hoursTotal / 24, hoursTotal % 24)
    }
}
