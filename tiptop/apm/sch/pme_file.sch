/*
================================================================================
檔案代號:pme_file
檔案名稱:送货地址/ 账单地址资料
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table pme_file
(
pme01       varchar2(10) NOT NULL,   /*地址编号                               */
                                     /*地址代號                               */
pme02       varchar2(1),             /*资料性质                               */
                                     /*資料性質                               */
                                     /*正確值 0/1/2                           */
                                     /*0.送貨地址                             */
                                     /*1.帳單地址                             */
                                     /*2.以上兩者                             */
pme031      varchar2(255),           /*地址(第一行)                           */
pme032      varchar2(255),           /*地址(第二行)                           */
pme033      varchar2(255),           /*地址(第三行)                           */
pme034      varchar2(255),           /*地址(第四行)                           */
pme035      varchar2(255),           /*地址(第五行)                           */
pmeacti     varchar2(1),             /*资料有效码                             */
                                     /*資料有效碼                             */
pmeuser     varchar2(10),            /*资料所有者                             */
                                     /*資料所有者                             */
pmegrup     varchar2(10),            /*资料所有部门                           */
                                     /*資料所有部門                           */
pmemodu     varchar2(10),            /*资料更改者                             */
                                     /*資料修改者                             */
pmedate     date,                    /*最近更改日                             */
                                     /*最近修改日                             */
pmeoriu     varchar2(10),            /*资料建立者                             */
pmeorig     varchar2(10)             /*资料建立部门                           */
);

alter table pme_file add  constraint pme_pk primary key  (pme01) enable validate;
grant select on pme_file to tiptopgp;
grant update on pme_file to tiptopgp;
grant delete on pme_file to tiptopgp;
grant insert on pme_file to tiptopgp;
grant index on pme_file to public;
grant select on pme_file to ods;
