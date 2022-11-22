<?php include APPROOT . "/php/views/common/header.php"; ?>

<div class="main">

    <div class="promotional">
        ENVÍOS GRATIS EN TODA LA TIENDA
    </div>

    <div class="item-card">
        <div class="item-image-container">
            <img src="<?php echo $data['product']->product_image; ?>"
                alt="<?php echo $data['product']->product_name; ?>" />
        </div>
        <div class="item-description-container">
            <div class="item-description">
                <div class="item-title">
                    <?php echo $data['product']->product_name; ?>
                </div>
                <div class="item-price">$
                    <?php echo $data['product']->product_price; ?>
                </div>
                <div class="item-monthly-payments">
                    Llevatelo a 6 pagos de
                    <?php echo '<b>$' . $data['sixPayments'][0]->monthly_payment . '</b>'; ?> o 12 pagos de
                    <?php echo '<b>$' . $data['twelvePayments'][0]->monthly_payment . '</b>'; ?>.
                </div>

                <div class="item-stars">
                    <?php for ($i = 0; $i < $data['product']->product_rating; $i++) {
                        echo "&#9733";
                    }
                    echo $data['product']->product_rating == 0 ? "<span>Sin calificaciones</span>" : ""; ?>
                </div>
                <button class="item-buy">Comprar</button>
                <div class="item-description-product">
                    <?php echo $data['product']->product_description; ?>
                </div>
            </div>
        </div>

        <h3 class="reviews-container">Reseñas</h3>

        <?php foreach ($data['reviews'] as $review): ?>

        <div class="item-description-reviews">
            <div class="item-stars">
                <?php for ($i = 0; $i < $review->rate; $i++) {
                echo "&#9733";
            }
                ?>
            </div>
            <div class="item-review-title">
                <b>
                    <?php echo $review->name; ?>
                </b>
            </div>
            <div class="item-review-description">
                <?php echo $review->text; ?>
            </div>
        </div>

        <hr>

        <?php endforeach; ?>

        <h3 class="recommendations">Puede que te guste</h3>

    </div>

</div>
<section class="product">
    <button class="pre-btn"><i class="ion ion-ios-arrow-forward"></i></button>
    <button class="nxt-btn"><i class="ion ion-ios-arrow-forward"></i></button>

    <div class="product-container">
        <?php foreach ($data['random_products'] as $product): ?>

        <a class="product-card" href="<?php echo URLROOT; ?>/producto/<?php echo $product->product_id; ?>">
            <div class="product-image">
                <img src="<?php echo $product->product_image; ?>" class="product-thumb"
                    alt="<?php echo $product->product_name; ?>">
            </div>
            <div class="product-info">
                <div class="product-brand">
                    <?php echo $product->product_name; ?>
                </div>
                <div class="price">$
                    <?php echo $product->product_price; ?>
                </div>
                <div class="rating">
                    <?php for ($i = 0; $i < $product->product_rating; $i++) {
                echo "&#9733";
            } ?>
                </div>
            </div>
        </a>

        <?php endforeach; ?>

    </div>
</section>

<?php include APPROOT . "/php/views/common/footer.php"; ?>