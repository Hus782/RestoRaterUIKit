//
//  Lingo.swift
//  RestoRaterUIKit
//
//  Created by user249550 on 12/22/23.
//

import Foundation

// All labels used in the app
// This setup allows for an easy localization of the app and addition of multple languages
struct Lingo {
    //    Common labels
    static let commonOk = String(localized: "common_ok")
    static let commonCancel = String(localized: "common_cancel")
    static let commonDelete = String(localized: "common_delete")
    static let commonEdit = String(localized: "common_edit")
    static let commonSave = String(localized: "common_save")
    static let commonError = String(localized: "common_error")
    static let commonConfirmDelete = String(localized: "common_confirm_delete")
    static let commonConfirmDeleteMessage = String(localized: "common_confirm_delete_message")
    static let commonErrorMessage = String(localized: "common_eror_message")
    static let commonSuccess = String(localized: "common_success")

    // ProfileView labels
    static let profileViewTitle = String(localized: "profile_view_title")
    static let profileViewNoUserLoggedIn = String(localized: "profile_view_no_user_logged_in")
    static let profileViewLogoutButton = String(localized: "profile_view_logout_button")
    static let profileViewNameTitle = String(localized: "profile_view_name_title")
    static let profileViewEmailTitle = String(localized: "profile_view_email_title")
    static let profileViewRoleTitle = String(localized: "profile_view_role_title")
    static let profileViewAdminRole = String(localized: "profile_view_admin_role")
    static let profileViewRegularUserRole = String(localized: "profile_view_regular_user_role")
    
    //    Users tab labels
    static let usersListTitle = String(localized: "users_list_title")
    static let addEditUserName = String(localized: "add_edit_user_name")
    static let addEditUserEmail = String(localized: "add_edit_user_email")
    static let addEditUserPassword = String(localized: "add_edit_user_password")
    static let addEditUserAdminAccess = String(localized: "add_edit_user_admin_access")
    static let addEditUserSaveButton = String(localized: "add_edit_user_save_button")
    static let addEditUserCreateTitle = String(localized: "add_edit_user_create_title")
    static let addEditUserEditTitle = String(localized: "add_edit_uesr_edit_title")
    
    static let userDetailsNameLabel = String(localized: "user_details_name_label")
    static let userDetailsEmailLabel = String(localized: "user_details_email_label")
    static let userDetailsRoleLabel = String(localized: "user_details_role_label")
    static let userDetailsRoleAdmin = String(localized: "user_details_role_admin")
    static let userDetailsRoleRegularUser = String(localized: "user_details_role_regular_user")
    static let userDetailsTitle = String(localized: "user_details_title")
    static let userDetailsDeleteConfirmation = String(localized: "user_details_delete_confirmation")
    static let userDetailsDeleteConfirmationDelete = String(localized: "user_details_delete_confirmation_delete")
    static let userDetailsErrorAlert = String(localized: "user_details_error_alert")
    
    //    Restaurant tab labels
    static let restaurantsListTitle = String(localized: "restaurants_list_title")
    static let addEditRestaurantName = String(localized: "add_edit_restaurant_name")
    static let addEditRestaurantAddress = String(localized: "add_edit_restaurant_address")
    static let addEditRestaurantImage = String(localized: "add_edit_restaurant_image")
    static let addEditRestaurantSelectImage = String(localized: "add_edit_restaurant_select_image")
    static let addEditRestaurantSaveButton = String(localized: "add_edit_restaurant_save_button")
    static let addEditRestaurantCreateTitle = String(localized: "add_edit_restaurant_create_title")
    static let addEditRestaurantEditTitle = String(localized: "add_edit_restaurant_edit_title")
    
    static let restaurantDetailTitle = String(localized: "restaurant_detail_title")
    static let restaurantDetailAverageRating = String(localized: "restaurant_detail_average_rating")
    static let restaurantDetailShowAllReviews = String(localized: "restaurant_detail_show_all_reviews")
    static let restaurantDetailAddReview = String(localized: "restaurant_detail_add_review")
    static let restaurantDetailConfirmDeleteMessage = String(localized: "restaurant_detail_confirm_delete_message")
    static let restaurantDetailError = String(localized: "restaurant_detail_error")
    static let reviewSectionLatestReview = String(localized: "review_section_latest_review")
    static let reviewSectionHighestRatedReview = String(localized: "review_section_highest_rated_review")
    static let reviewSectionLowestRatedReview = String(localized: "review_section_lowest_rated_review")
    
    //    Reviews list
    static let reviewsListViewError = String(localized: "reviews_list_view_error")
    static let reviewsListViewConfirmDeleteMessage = String(localized: "reviews_list_view_confirm_delete_message")
    static let reviewListTitle = String(localized: "reivew_list_title")
    
    static let addEditReviewRating = String(localized: "add_edit_review_rating")
    static let addEditReviewComment = String(localized: "add_edit_review_comment")
    static let addEditReviewDateOfVisit = String(localized: "add_edit_review_date_of_visit")
    static let addEditReviewSubmitButton = String(localized: "add_edit_review_submit_button")
    static let addEditReviewNavigationTitleAdd = String(localized: "add_edit_review_navigation_title_add")
    static let addEditReviewNavigationTitleEdit = String(localized: "add_edit_review_navigation_title_edit")
    static let addEditReviewCreateTitle = String(localized: "add_edit_review_create_title")
    static let addEditReviewEditTitle = String(localized: "add_edit_review_edit_title")
    
    // Login screen
    static let loginViewEmailPlaceholder = String(localized: "login_view_email_placeholder")
    static let loginViewPasswordPlaceholder = String(localized: "login_view_password_placeholder")
    static let loginViewLoginButton = String(localized: "login_view_login_button")
    static let loginViewRegisterButton = String(localized: "login_view_register_button")
    static let loginViewLoginAlertTitle = String(localized: "login_view_login_alert_title")
    static let invalidCredentials = String(localized: "invalidCredentialsKey")
    static let loginFailed = String(localized: "loginFailedKey")
    
    //     Register screen
    static let registerViewEmailPlaceholder = String(localized: "register_view_email_placeholder")
    static let registerViewPasswordPlaceholder = String(localized: "register_view_password_placeholder")
    static let registerViewNamePlaceholder = String(localized: "register_view_name_placeholder")
    static let registerViewIsAdminLabel = String(localized: "register_view_is_admin_label")
    static let registerViewRegisterButton = String(localized: "register_view_register_button")
    static let registerViewLoginButton = String(localized: "register_view_login_button")
    static let registrationFailed = String(localized: "registrationFailedKey")
    static let registrationSuccess = String(localized: "register_success")
    static let emailTakenMessage = String(localized: "email_taken")
    
    // Tabbar labels
    static let restaurantTab = String(localized: "restaurants_tab")
    static let usersTab = String(localized: "users_tab")
    static let profileTab = String(localized: "profile_tab")
    
    // Field validation messages
    static let invalidEmailFormat = String(localized: "invalid_email_format")
    static let fieldCannotBeEmpty = String(localized: "field_cannot_be_empty")
    static let passwordLengthErrorPrefix = String(localized: "password_length_error_prefix")
    static let passwordLengthErrorSuffix = String(localized: "password_length_error_suffix")
    static let textMinimumLengthErrorPrefix = String(localized: "text_minimum_length_error_prefix")
    static let textMinimumLengthErrorSuffix = String(localized: "text_minimum_length_error_suffix")
    static let textMaximumLengthErrorPrefix = String(localized: "text_maximum_length_error_prefix")
    static let textMaximumLengthErrorSuffix = String(localized: "text_maximum_length_error_suffix")
    
}
