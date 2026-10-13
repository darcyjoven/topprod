/*
================================================================================
檔案代號:rcb_file
檔案名稱:专柜抽成资料第一单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table rcb_file
(
rcb01       varchar2(10) DEFAULT ' ' NOT NULL, /*营运中心编号*/
rcb02       date DEFAULT sysdate NOT NULL, /*生效日期*/
rcb03       date DEFAULT sysdate NOT NULL, /*失效日期*/
rcb04       number(5) DEFAULT '0' NOT NULL, /*项次*/
rcb05       varchar2(10),            /*抽成编号                               */
rcb06       number(6,2),             /*折数(%)起                              */
rcb07       number(6,2),             /*折数(%)迄                              */
rcb08       number(6,2),             /*抽成率                                 */
rcb09       varchar2(1) NOT NULL,    /*设定产品分群类型否                     */
rcbacti     varchar2(1) DEFAULT ' ' NOT NULL /*资料有效码*/
);

alter table rcb_file add  constraint rcb_pk primary key  (rcb01,rcb02,rcb03,rcb04) enable validate;
grant select on rcb_file to tiptopgp;
grant update on rcb_file to tiptopgp;
grant delete on rcb_file to tiptopgp;
grant insert on rcb_file to tiptopgp;
grant index on rcb_file to public;
grant select on rcb_file to ods;
