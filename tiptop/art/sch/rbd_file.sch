/*
================================================================================
檔案代號:rbd_file
檔案名稱:一般促销变更第二单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table rbd_file
(
rbd01       varchar2(10) DEFAULT ' ' NOT NULL, /*制定机构*/
rbd02       varchar2(20) DEFAULT ' ' NOT NULL, /*促销单号*/
rbd03       number(5) DEFAULT '0' NOT NULL, /*变动序号*/
rbd04       number(5) DEFAULT '0' NOT NULL, /*序号*/
rbd05       varchar2(1) DEFAULT ' ' NOT NULL, /*資料類型:0初始1修改*/
rbd06       number(5) DEFAULT '0' NOT NULL, /*组别*/
rbd07       varchar2(2) DEFAULT ' ' NOT NULL, /*数据类型01.产品、02.产品分类 */
rbd08       varchar2(40),            /*代码                                   */
rbd09       varchar2(4),             /*单位                                   */
rbdacti     varchar2(1) DEFAULT ' ' NOT NULL, /*资料有效码*/
rbdlegal    varchar2(10) DEFAULT ' ' NOT NULL, /*法人别*/
rbdplant    varchar2(10) DEFAULT ' ' NOT NULL /*营运中心编号*/
);

alter table rbd_file add  constraint rbd_pk primary key  (rbd01,rbd02,rbd03,rbd04,rbd05,rbd06,rbd07,rbdplant) enable validate;
grant select on rbd_file to tiptopgp;
grant update on rbd_file to tiptopgp;
grant delete on rbd_file to tiptopgp;
grant insert on rbd_file to tiptopgp;
grant index on rbd_file to public;
grant select on rbd_file to ods;
