/*
================================================================================
檔案代號:obj_file
檔案名稱:混合包装方式档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table obj_file
(
obj01       varchar2(20) DEFAULT ' ' NOT NULL, /*混装编号*/
obj02       varchar2(40) NOT NULL,   /*料号                                   */
obj03       varchar2(80),            /*品名                                   */
obj04       number(15,3),            /*内包装数量                             */
obj05       number(15,3),            /*内包装含产品数量                       */
obj06       number(15,3),            /*产品装数                               */
obj07       varchar2(4),             /*单位                                   */
obj08       number(15,3),            /*内包装长                               */
obj09       number(15,3),            /*内包装宽                               */
obj10       number(15,3),            /*内包装高                               */
obj11       number(15,3),            /*内包装体积                             */
obj12       number(15,3),            /*内包装重量                             */
obj13       number(15,3),            /*单个产品净重                           */
obj14       varchar2(255)            /*备注                                   */
);

alter table obj_file add  constraint obj_pk primary key  (obj01,obj02) enable validate;
grant select on obj_file to tiptopgp;
grant update on obj_file to tiptopgp;
grant delete on obj_file to tiptopgp;
grant insert on obj_file to tiptopgp;
grant index on obj_file to public;
grant select on obj_file to ods;
