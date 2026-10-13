/*
================================================================================
檔案代號:lib_file
檔案名稱:摊位申请单单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table lib_file
(
lib01       varchar2(20) DEFAULT ' ' NOT NULL, /*摊位申请单号*/
lib02       date,                    /*申请日期                               */
lib03       varchar2(1) DEFAULT ' ' NOT NULL, /*申请类型*/
lib04       varchar2(20),            /*合同面積變更申請單                     */
lib05       varchar2(20),            /*摊位编号                               */
lib06       number(5),               /*版本号                                 */
lib07       varchar2(10),            /*楼栋编号                               */
lib08       varchar2(10),            /*楼层编号                               */
lib09       number(20,6),            /*原建築面積                             */
lib091      number(20,6),            /*建筑面积                               */
lib10       number(20,6),            /*原測量面積                             */
lib101      number(20,6),            /*測量面積                               */
lib11       number(20,6),            /*原經營面積                             */
lib111      number(20,6),            /*经营面积                               */
lib12       varchar2(10),            /*攤位用途                               */
lib13       varchar2(200),           /*門牌號                                 */
lib14       varchar2(1) DEFAULT ' ' NOT NULL, /*攤位狀態*/
lib15       varchar2(255),           /*备注                                   */
lib16       varchar2(1) DEFAULT ' ' NOT NULL, /*状况码*/
libacti     varchar2(1) DEFAULT ' ' NOT NULL, /*资料有效码*/
libcond     date,                    /*审核日期                               */
libconf     varchar2(1) DEFAULT ' ' NOT NULL, /*确认码*/
libconu     varchar2(10),            /*审核人                                 */
libcrat     date,                    /*资料创建日                             */
libdate     date,                    /*最近更改日                             */
libgrup     varchar2(10),            /*资料所有群                             */
liblegal    varchar2(10),            /*所属法人                               */
libmksg     varchar2(1) NOT NULL,    /*是否签核                               */
libmodu     varchar2(10),            /*资料更改者                             */
liborig     varchar2(10),            /*资料建立部门                           */
liboriu     varchar2(10),            /*资料建立者                             */
libplant    varchar2(10) DEFAULT ' ' NOT NULL, /*所属营运中心*/
libuser     varchar2(10)             /*资料所有者                             */
);

alter table lib_file add  constraint lib_pk primary key  (lib01) enable validate;
grant select on lib_file to tiptopgp;
grant update on lib_file to tiptopgp;
grant delete on lib_file to tiptopgp;
grant insert on lib_file to tiptopgp;
grant index on lib_file to public;
grant select on lib_file to ods;
