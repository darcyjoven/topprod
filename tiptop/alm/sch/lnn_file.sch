/*
================================================================================
檔案代號:lnn_file
檔案名稱:战盟连锁优惠信息单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:P
多語系檔案:N
============.========================.==========================================
*/
create table lnn_file
(
lnn01       varchar2(10),            /*no use 原门店编号                      */
lnn02       varchar2(1) DEFAULT ' ' NOT NULL, /*经营类型*/
lnn03       varchar2(20),            /*本店所属区域                           */
lnn04       number(6,2),             /*本店内连锁取                           */
lnn05       number(6,2),             /*本店所属区域取                         */
lnn06       number(6,2),             /*其他区域取                             */
lnn07       varchar2(1),             /*确认码                                 */
lnn08       varchar2(10),            /*审核人                                 */
lnn09       date,                    /*审核日期                               */
lnnacti     varchar2(1),             /*资料有效码                             */
lnncrat     date,                    /*资料创建日                             */
lnndate     date,                    /*最近更改日                             */
lnngrup     varchar2(10),            /*资料所有群                             */
lnnlegal    varchar2(10) NOT NULL,   /*所属法人                               */
lnnmodu     varchar2(10),            /*资料更改者                             */
lnnuser     varchar2(10),            /*资料所有者                             */
lnnoriu     varchar2(10),            /*资料建立者                             */
lnnorig     varchar2(10),            /*资料建立部门                           */
lnnstore    varchar2(10) DEFAULT ' ' NOT NULL /*门店编号*/
);

alter table lnn_file add  constraint lnn_pk primary key  (lnnstore,lnn02) enable validate;
grant select on lnn_file to tiptopgp;
grant update on lnn_file to tiptopgp;
grant delete on lnn_file to tiptopgp;
grant insert on lnn_file to tiptopgp;
grant index on lnn_file to public;
grant select on lnn_file to ods;
