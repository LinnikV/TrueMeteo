require "application_system_test_case"

class NewsTest < ApplicationSystemTestCase
  setup do
    @news = news(:one)
  end

  test "visiting the index" do
    visit news_url
    assert_selector "h1", text: "News"
  end

  test "should create news" do
    visit news_url
    click_on "New news"

    fill_in "Admin id", with: @news.admin_id
    fill_in "Body", with: @news.body
    fill_in "Date", with: @news.date
    fill_in "Header", with: @news.header
    fill_in "Image", with: @news.image
    check "Publish" if @news.publish
    fill_in "Source", with: @news.source
    fill_in "Title", with: @news.title
    click_on "Create News"

    assert_text "News was successfully created"
    click_on "Back"
  end

  test "should update News" do
    visit news_url(@news)
    click_on "Edit this news", match: :first

    fill_in "Admin id", with: @news.admin_idadmin_id_id
    fill_in "Body", with: @news.body
    fill_in "Date", with: @news.date
    fill_in "Header", with: @news.header
    fill_in "Image", with: @news.image
    check "Publish" if @news.publish
    fill_in "Source", with: @news.source
    fill_in "Title", with: @news.title
    click_on "Update News"

    assert_text "News was successfully updated"
    click_on "Back"
  end

  test "should destroy News" do
    visit news_url(@news)
    click_on "Destroy this news", match: :first

    assert_text "News was successfully destroyed"
  end
end
