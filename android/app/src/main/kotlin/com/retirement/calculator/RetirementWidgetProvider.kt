package com.retirement.calculator

import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.widget.RemoteViews
import android.content.SharedPreferences
import java.text.SimpleDateFormat
import java.util.*

class RetirementWidgetProvider : AppWidgetProvider() {

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray
    ) {
        for (appWidgetId in appWidgetIds) {
            updateAppWidget(context, appWidgetManager, appWidgetId)
        }
    }

    companion object {
        private const val PREFS_NAME = "FlutterSharedPreferences"
        private const val KEY_BIRTH_DATE = "flutter.birth_date"
        private const val KEY_COUNTRY_CODE = "flutter.country_code"
        private const val KEY_IS_MALE = "flutter.is_male"
        private const val KEY_COUNTDOWN_TYPE = "flutter.countdown_type"

        private fun getRetirementAge(countryCode: String, isMale: Boolean): Int {
            return when (countryCode) {
                "RO" -> if (isMale) 65 else 63
                "DE" -> 67
                "FR" -> 64
                "IT" -> 67
                "ES" -> 66
                "UK" -> 66
                "US" -> 67
                "CA" -> 65
                "AU" -> 67
                "NL" -> 67
                "BE" -> 66
                "AT" -> if (isMale) 65 else 60
                "CH" -> if (isMale) 65 else 64
                else -> 65
            }
        }

        private fun calculateTimeToRetirement(
            birthDate: Date,
            retirementAge: Int
        ): RetirementCalculation? {
            val calendar = Calendar.getInstance()
            calendar.time = birthDate
            calendar.add(Calendar.YEAR, retirementAge)
            val retirementDate = calendar.time

            val now = Date()
            if (now.after(retirementDate)) {
                return null
            }

            val diff = retirementDate.time - now.time
            val totalDays = (diff / (1000 * 60 * 60 * 24)).toInt()
            val totalMonths = (totalDays / 30.44).toInt()
            val totalYears = (totalDays / 365.25).toInt()

            // Calculate detailed breakdown
            val startCal = Calendar.getInstance()
            startCal.time = now
            val endCal = Calendar.getInstance()
            endCal.time = retirementDate

            var years = 0
            var months = 0
            var days = 0

            years = endCal.get(Calendar.YEAR) - startCal.get(Calendar.YEAR)
            months = endCal.get(Calendar.MONTH) - startCal.get(Calendar.MONTH)
            days = endCal.get(Calendar.DAY_OF_MONTH) - startCal.get(Calendar.DAY_OF_MONTH)

            if (days < 0) {
                months--
                val tempCal = endCal.clone() as Calendar
                tempCal.add(Calendar.MONTH, -1)
                days += tempCal.getActualMaximum(Calendar.DAY_OF_MONTH)
            }

            if (months < 0) {
                years--
                months += 12
            }

            return RetirementCalculation(
                retirementDate = retirementDate,
                totalDays = totalDays,
                totalMonths = totalMonths,
                totalYears = totalYears,
                years = years,
                months = months,
                days = days
            )
        }

        private fun updateAppWidget(
            context: Context,
            appWidgetManager: AppWidgetManager,
            appWidgetId: Int
        ) {
            val prefs = context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)

            val birthDateStr = prefs.getString(KEY_BIRTH_DATE, null)
            val countryCode = prefs.getString(KEY_COUNTRY_CODE, "RO") ?: "RO"
            val isMale = prefs.getBoolean(KEY_IS_MALE, true)
            val countdownType = prefs.getInt(KEY_COUNTDOWN_TYPE, 0)

            val views = RemoteViews(context.packageName, R.layout.retirement_widget)

            if (birthDateStr != null) {
                try {
                    val dateFormat = SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'", Locale.US)
                    val birthDate = dateFormat.parse(birthDateStr)

                    if (birthDate != null) {
                        val retirementAge = getRetirementAge(countryCode, isMale)
                        val calculation = calculateTimeToRetirement(birthDate, retirementAge)

                        if (calculation != null) {
                            val (value, label) = when (countdownType) {
                                0 -> Pair(calculation.totalDays.toString(), "zile")
                                1 -> Pair(calculation.totalMonths.toString(), "luni")
                                2 -> Pair(calculation.totalYears.toString(), "ani")
                                else -> Pair(calculation.totalDays.toString(), "zile")
                            }

                            views.setTextViewText(R.id.widget_countdown_value, value)
                            views.setTextViewText(R.id.widget_countdown_label, label)
                            views.setTextViewText(
                                R.id.widget_detailed_countdown,
                                "${calculation.years} ani, ${calculation.months} luni, ${calculation.days} zile"
                            )
                        } else {
                            views.setTextViewText(R.id.widget_countdown_value, "🎉")
                            views.setTextViewText(R.id.widget_countdown_label, "Pensionat!")
                            views.setTextViewText(R.id.widget_detailed_countdown, "")
                        }
                    }
                } catch (e: Exception) {
                    views.setTextViewText(R.id.widget_countdown_value, "?")
                    views.setTextViewText(R.id.widget_countdown_label, "eroare")
                    views.setTextViewText(R.id.widget_detailed_countdown, "")
                }
            } else {
                views.setTextViewText(R.id.widget_countdown_value, "?")
                views.setTextViewText(R.id.widget_countdown_label, "")
                views.setTextViewText(
                    R.id.widget_detailed_countdown,
                    "Configurează în aplicație"
                )
            }

            appWidgetManager.updateAppWidget(appWidgetId, views)
        }
    }
}

data class RetirementCalculation(
    val retirementDate: Date,
    val totalDays: Int,
    val totalMonths: Int,
    val totalYears: Int,
    val years: Int,
    val months: Int,
    val days: Int
)
