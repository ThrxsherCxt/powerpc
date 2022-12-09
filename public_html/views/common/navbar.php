<header class="header">
    <div class="container">
        <div class="wrapper">
            <button type="button" class="menu-mobile-trigger">
                <i class="ion ion-md-menu"></i>
            </button>
            <div class="header-item-left">
                <a href="<?php echo URLROOT; ?>" class="brand"><img id="logo"
                        src="<?php echo URLROOT; ?>/assets/img/logo_dark.png" /></a>
            </div>
            <div class="header-item-center">
                <div class="overlay"></div>
                <nav class="menu">
                    <div class="menu-mobile-header">
                        <button type="button" class="menu-mobile-arrow"><i class="ion ion-ios-arrow-back"></i></button>
                        <div class="menu-mobile-title"></div>
                        <button type="button" class="menu-mobile-close"><i class="ion ion-ios-close"></i></button>
                    </div>

                    <ul class="menu-section">
                        <li><a href="<?php echo URLROOT; ?>">Inicio</a></li>
                        <li class="menu-item-has-children">
                            <a href="#">Categorías <i class="ion ion-ios-arrow-down"></i></a>
                            <div class="menu-subs menu-mega menu-column-4">

                                <?php foreach (unserialize(CATEGORIES) as $category): ?>

                                <div class="list-item">

                                    <h4 class="title">
                                        <a href="<?php echo URLROOT; ?>/categoria/<?php echo $category->id; ?>">
                                            <?php echo $category->name; ?>
                                        </a>
                                    </h4>

                                    <?php if (isset($category->children)) { ?>

                                    <ul>
                                        <?php foreach ($category->children as $category_children): ?>
                                        <li>
                                            <a
                                                href="<?php echo URLROOT; ?>/categoria/<?php echo $category_children->id; ?>">
                                                <?php echo $category_children->name; ?>
                                            </a>
                                        </li>
                                        <?php endforeach; ?>

                                    </ul>

                                    <?php } ?>

                                </div>

                                <?php endforeach; ?>

                            </div>
                        </li>
                        <li><a href="<?php echo URLROOT; ?>/productos/destacados">Destacados</a></li>
                        <li><a href="<?php echo URLROOT; ?>/productos/mas_vendidos">Más vendidos</a></li>
                        <li><a href="#">Acerca de</a></li>
                    </ul>
                </nav>
            </div>

            <div class="header-item-right">
                <a href="#" class="menu-icon"><i class="ion ion-md-search"></i></a>
                <a href="#" class="menu-icon"><i class="ion ion-md-person"></i></a>
                <a href="#" class="menu-icon"><i class="ion ion-md-cart"></i></a>
            </div>
        </div>
    </div>
</header>