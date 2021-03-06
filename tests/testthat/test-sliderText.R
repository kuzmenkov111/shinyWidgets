context("sliderText")


test_that("default", {

  tagst <- sliderTextInput(
    inputId = "MY_ID",
    label = "Month range slider:",
    choices = month.name,
    selected = month.name[c(4, 7)]
  )

  expect_is(tagst, "shiny.tag")
  expect_length(htmltools::findDependencies(tagst), 3)
  expect_identical(htmltools::findDependencies(tagst)[[1]]$script, "js/ion.rangeSlider.min.js")
  expect_true(htmltools::tagHasAttribute(tagst$children[[2]], "id"))
  expect_identical(htmltools::tagGetAttribute(tagst$children[[2]], "id"), "MY_ID")
})


test_that("animation", {

  tagst <- sliderTextInput(
    inputId = "MY_ID",
    label = "Month range slider:",
    choices = month.name,
    selected = month.name[c(4, 7)],
    animate = TRUE
  )

  expect_is(tagst, "shiny.tag")
  expect_true(htmltools::tagHasAttribute(tagst$children[[3]], "class"))
  expect_identical(htmltools::tagGetAttribute(tagst$children[[3]], "class"), "slider-animate-container")
})



test_that("updateSliderTextInput", {

  session <- as.environment(list(
    sendInputMessage = function(inputId, message) {
      session$lastInputMessage = list(id = inputId, message = message)
    },
    sendCustomMessage = function(type, message) {
      session$lastCustomMessage <- list(type = type, message = message)
    },
    sendInsertUI = function(selector, multiple,
                            where, content) {
      session$lastInsertUI <- list(selector = selector, multiple = multiple,
                                   where = where, content = content)
    },
    onFlushed = function(callback, once) {
      list(callback = callback, once = once)
    }
  ))

  updateSliderTextInput(
    session = session,
    inputId = "mySlider",
    choices = month.name,
    selected = month.name[9]
  )

  msgst <- session$lastInputMessage
  expect_length(msgst, 2)
  expect_identical(msgst$id, "mySlider")
  expect_identical(msgst$message$selected, "September")
  expect_length(msgst$message$choices, 12)
})
