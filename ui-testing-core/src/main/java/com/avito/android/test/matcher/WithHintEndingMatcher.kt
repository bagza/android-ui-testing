package com.avito.android.test.matcher;

import android.support.test.espresso.matcher.BoundedMatcher
import android.view.View
import android.widget.TextView
import org.hamcrest.Description

class WithHintEndingMatcher(private val hint: CharSequence) : BoundedMatcher<View, TextView>(TextView::class.java) {

    override fun describeTo(description: Description) {
        description.appendText("ends with hint: $hint")
    }

    public override fun matchesSafely(textView: TextView): Boolean {
        return textView.hint.endsWith(hint)
    }
}