/*
================================================================================
檔案代號:rtb_file
檔案名稱:商品结构资料单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table rtb_file
(
rtb01       varchar2(40) DEFAULT ' ' NOT NULL, /*组装产品主项产品编号*/
rtb02       varchar2(4),             /*库存单位                               */
rtb03       number(5),               /*主项产品数量                           */
rtbacti     varchar2(1),             /*资料有效码                             */
rtbcrat     date,                    /*资料更改日                             */
rtbdate     date,                    /*最近更改日                             */
rtbgrup     varchar2(10),            /*资料所有部门                           */
rtbmodu     varchar2(10),            /*资料更改者                             */
rtbuser     varchar2(10),            /*资料所有者                             */
rtbpos      varchar2(1) DEFAULT '1' NOT NULL, /*已传POS否*/
rtborig     varchar2(10),            /*资料建立部门                           */
rtboriu     varchar2(10)             /*资料建立者                             */
);

alter table rtb_file add  constraint rtb_pk primary key  (rtb01) enable validate;
grant select on rtb_file to tiptopgp;
grant update on rtb_file to tiptopgp;
grant delete on rtb_file to tiptopgp;
grant insert on rtb_file to tiptopgp;
grant index on rtb_file to public;
grant select on rtb_file to ods;
