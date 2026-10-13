/*
================================================================================
檔案代號:lqe_file
檔案名稱:券使用信息记录
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table lqe_file
(
lqe01       varchar2(20) DEFAULT ' ' NOT NULL, /*券编号*/
lqe02       varchar2(20),            /*券种编号                               */
lqe03       varchar2(10),            /*券面额编号                             */
lqe04       varchar2(10),            /*登记门店编号                           */
lqe05       date,                    /*登记日期                               */
lqe06       varchar2(10),            /*发售门店编号                           */
lqe07       date,                    /*发售日期                               */
lqe08       number(6,2),             /*券折扣率                               */
lqe09       varchar2(10),            /*退回门店编号                           */
lqe10       date,                    /*退回日期                               */
lqe11       varchar2(10),            /*作废门店编号                           */
lqe12       date,                    /*作废日期                               */
lqe13       varchar2(10),            /*发放门店编号                           */
lqe14       date,                    /*发放日期                               */
lqe15       varchar2(10),            /*回收门店编号                           */
lqe16       date,                    /*回收日期                               */
lqe17       varchar2(1) DEFAULT ' ' NOT NULL, /*券流转状态*/
                                     /*0.登记, 1.出售, 2.退回, 3.作废, 4.核销, 5.发放, 6.回收*/
lqe18       varchar2(10),            /*核销门店                               */
lqe19       date,                    /*核销日期                               */
lqe20       date,                    /*生效日期                               */
lqe21       date,                    /*截止日期                               */
lqepos      varchar2(1) DEFAULT '1' NOT NULL, /*已传POS否*/
lqe22       varchar2(1) DEFAULT '0' NOT NULL, /*赠券来源*/
lqe23       number(20,6) DEFAULT '0' NOT NULL, /*递延金额*/
lqe24       varchar2(10),            /*使用门店                               */
lqe25       date                     /*使用日期                               */
);

alter table lqe_file add  constraint lqe_pk primary key  (lqe01) enable validate;
grant select on lqe_file to tiptopgp;
grant update on lqe_file to tiptopgp;
grant delete on lqe_file to tiptopgp;
grant insert on lqe_file to tiptopgp;
grant index on lqe_file to public;
grant select on lqe_file to ods;
