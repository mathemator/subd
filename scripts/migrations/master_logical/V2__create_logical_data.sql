create table public.logical_data(cat_id int not null,
    cat_name varchar(30) not null,
    favorite_toy varchar(100),
    primary key (cat_id)
);

insert into public.logical_data values (1, 'Makotjkins', 'rolling ball');

create publication logical_pub for table public.logical_data;