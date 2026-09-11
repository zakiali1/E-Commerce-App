# Full E-Commerce Application Architecture Implementation Plan

Transform the existing prototype into a feature-complete, production-grade Flutter E-Commerce mobile application equipped with state management, persistent shopping cart, checkout flow, product detail views, order management, user authentication, and search/filter capabilities.

## User Review Required

> [!IMPORTANT]
> - **State Management**: We will introduce `provider` as the core state management package to seamlessly sync Cart, User Auth, Wishlist, and Orders across all screens.
> - **Local Data Persistence**: Shopping cart items and user session details will be saved to `shared_preferences` so they persist when closing/reopening the app.
> - **Backend API**: Data will be driven dynamically by the FakeStore REST API (`https://fakestoreapi.com/products`) with robust offline/fallback mock data handling.

## Open Questions

> [!NOTE]
> None at present. The proposed architecture covers all fundamental e-commerce requirements end-to-end.

---

## Proposed Changes

### Dependencies & Configuration

#### [MODIFY] [`pubspec.yaml`](file:///c:/Users/Hp/Downloads/Projects/ecommerce/pubspec.yaml)
- Add `provider` (^6.1.2) for app-wide reactive state management.
- Add `shared_preferences` (^2.2.3) for local storage of cart and auth state.
- Add `intl` (^0.19.0) for currency and date formatting.
- Add `flutter_rating_bar` (^4.0.1) for product ratings.

---

### Data Models & Services (`lib/models`, `lib/services`, `lib/providers`)

#### [NEW] [`product.dart`](file:///c:/Users/Hp/Downloads/Projects/ecommerce/lib/models/product.dart)
- Create `Product` model with `id`, `title`, `price`, `description`, `category`, `image`, `rating`, `reviews`, `sizes`, `colors`.

#### [MODIFY] [`cart_item.dart`](file:///c:/Users/Hp/Downloads/Projects/ecommerce/lib/models/cart_item.dart)
- Enhance `CartItem` model to wrap full `Product` data, chosen size, color, quantity, and serialization (`toJson` / `fromJson`).

#### [NEW] [`order.dart`](file:///c:/Users/Hp/Downloads/Projects/ecommerce/lib/models/order.dart)
- Create `OrderItem` and `Order` models with tracking status, shipping address, payment method, date, and order total.

#### [NEW] [`user_model.dart`](file:///c:/Users/Hp/Downloads/Projects/ecommerce/lib/models/user_model.dart)
- Create `UserModel` containing profile info, saved addresses, and active token.

#### [NEW] [`cart_provider.dart`](file:///c:/Users/Hp/Downloads/Projects/ecommerce/lib/providers/cart_provider.dart)
- Reactive provider for adding, removing, updating quantities, calculating subtotals/taxes/discounts, clearing cart, and persisting to disk.

#### [NEW] [`auth_provider.dart`](file:///c:/Users/Hp/Downloads/Projects/ecommerce/lib/providers/auth_provider.dart)
- Reactive provider for user login, signup, logout, updating profile details, and managing persistent auth state.

#### [NEW] [`wishlist_provider.dart`](file:///c:/Users/Hp/Downloads/Projects/ecommerce/lib/providers/wishlist_provider.dart)
- Reactive provider for toggling item bookmarks/favorites.

#### [NEW] [`order_provider.dart`](file:///c:/Users/Hp/Downloads/Projects/ecommerce/lib/providers/order_provider.dart)
- Reactive provider for placing new orders and retrieving order history.

#### [NEW] [`product_service.dart`](file:///c:/Users/Hp/Downloads/Projects/ecommerce/lib/services/product_service.dart)
- API service wrapper for fetching products, filtering by category, and searching.

---

### Presentation & Navigation (`lib/views`, `lib/widgets`)

#### [MODIFY] [`main.dart`](file:///c:/Users/Hp/Downloads/Projects/ecommerce/lib/main.dart)
- Wrap app root with `MultiProvider`.
- Configure custom theme (Primary Green, Accent Orange, modern cards, standard typography).

#### [MODIFY] [`homeScreen.dart`](file:///c:/Users/Hp/Downloads/Projects/ecommerce/lib/views/homeScreen.dart)
- Connect to `CartProvider`, `WishlistProvider`, and `ProductService`.
- Add search bar with real-time query filtering, category chips, banner carousel, wishlist badges, and seamless tab switching.

#### [NEW] [`productDetailScreen.dart`](file:///c:/Users/Hp/Downloads/Projects/ecommerce/lib/views/productDetailScreen.dart)
- Implement full product preview screen: image gallery, price, star ratings, variant selector (Size/Color), description, and "Add to Cart" / "Buy Now" actions.

#### [MODIFY] [`cartScreen.dart`](file:///c:/Users/Hp/Downloads/Projects/ecommerce/lib/views/cartScreen.dart)
- Upgrade from static placeholder to fully dynamic cart screen.
- List cart items with image previews, price breakdown, quantity increment/decrement, item deletion, promo code input, and "Proceed to Checkout" button.

#### [NEW] [`checkoutScreen.dart`](file:///c:/Users/Hp/Downloads/Projects/ecommerce/lib/views/checkoutScreen.dart)
- Step-by-step checkout UI: Delivery address input, shipping method, payment selection (Credit Card, Bank Transfer, Cash on Delivery), and payment processing.

#### [NEW] [`orderSuccessScreen.dart`](file:///c:/Users/Hp/Downloads/Projects/ecommerce/lib/views/orderSuccessScreen.dart)
- Order completion celebration page with receipt summary and quick links back to Home or Order History.

#### [NEW] [`orderHistoryScreen.dart`](file:///c:/Users/Hp/Downloads/Projects/ecommerce/lib/views/orderHistoryScreen.dart)
- Displays user's past orders with status badges (*Processing*, *Shipped*, *Delivered*).

#### [NEW] [`wishlistScreen.dart`](file:///c:/Users/Hp/Downloads/Projects/ecommerce/lib/views/wishlistScreen.dart)
- View saved products and quickly move them to the shopping cart.

#### [MODIFY] [`catScreen.dart`](file:///c:/Users/Hp/Downloads/Projects/ecommerce/lib/views/catScreen.dart)
- Enhance category browsing to filter products when tapping a category.

#### [MODIFY] [`loginScreen.dart`](file:///c:/Users/Hp/Downloads/Projects/ecommerce/lib/views/loginScreen.dart) & [`signupScreen.dart`](file:///c:/Users/Hp/Downloads/Projects/ecommerce/lib/views/signupScreen.dart)
- Connect to `AuthProvider` for real authentication validation and user redirection.

#### [MODIFY] [`profileScreen.dart`](file:///c:/Users/Hp/Downloads/Projects/ecommerce/lib/views/profileScreen.dart)
- Bind profile user details to `AuthProvider` and hook up Order History, Address Editing, and Logout handlers.

#### [NEW] [`bottom_nav_bar.dart`](file:///c:/Users/Hp/Downloads/Projects/ecommerce/lib/widgets/bottom_nav_bar.dart)
- Reusable bottom navigation bar with real-time Cart item badge count across all primary screens.

---

## Verification Plan

### Automated Tests
- Run `flutter analyze` to ensure zero compilation or static lint errors.
- Run existing and new widget/unit tests using `flutter test`.

### Manual Verification
- Test adding items to cart from Home and Product Details screens; verify Cart counter badge updates everywhere.
- Test modifying quantities and deleting items in CartScreen; verify subtotal, tax, and total update dynamically.
- Test complete Checkout flow: select address $\rightarrow$ choose payment method $\rightarrow$ place order $\rightarrow$ view Order Success $\rightarrow$ check Order History.
- Test persistent cart: restart app/hot restart and verify cart items remain stored.
- Test user Auth flow (Login, Signup, Logout, Profile update).
