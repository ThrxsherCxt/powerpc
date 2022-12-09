<?php include APPROOT . "/public_html/views/common/header.php"; ?>
<div class="main">

    <div class="promotional">
        ENVÍOS GRATIS EN TODA LA TIENDA
    </div>

    <div class="banner-buen-fin">
        <img src=" <?php echo URLROOT . "/assets/img/Banner_buen_fin.jpg"; ?>">
    </div>

    <div class="buen-fin-title">
        <div>PRODUCTOS DESTACADOS</div>
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

    <div class="see-all-div">
        <a href="<?php echo URLROOT; ?>/productos/destacados">
            <div class="see-all-btn">
                VER MÁS &nbsp;<i class="ion ion-ios-arrow-forward"></i>
            </div>
        </a>
    </div>

    <div class="buen-fin-title">
        <div>MÁS VENDIDOS</div>
    </div>

    <section class="product">
        <button class="pre-btn"><i class="ion ion-ios-arrow-forward"></i></button>
        <button class="nxt-btn"><i class="ion ion-ios-arrow-forward"></i></button>
        <div class="product-container">


            <?php foreach ($data['best_rating'] as $product): ?>

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

    <div class="see-all-div">
        <a href="<?php echo URLROOT; ?>/productos/mas_vendidos">
            <div class="see-all-btn">
                VER MÁS &nbsp;<i class="ion ion-ios-arrow-forward"></i>
            </div>
        </a>
    </div>

</div>
<?php include APPROOT . "/public_html/views/common/footer.php"; ?>