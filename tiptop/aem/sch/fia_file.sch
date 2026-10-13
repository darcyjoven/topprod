/*
================================================================================
檔案代號:fia_file
檔案名稱:设备基本资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table fia_file
(
fia01       varchar2(20) NOT NULL,   /*设备编号                               */
fia011      varchar2(10),            /*财产编号                               */
fia012      varchar2(4),             /*附号                                   */
fia02       varchar2(80),            /*名称                                   */
fia03       varchar2(10),            /*类型                                   */
fia04       varchar2(30),            /*系列号                                 */
fia05       varchar2(30),            /*型号                                   */
fia06       varchar2(30),            /*铭牌                                   */
fia07       varchar2(10),            /*制造商
                                                                                   */
fia08       varchar2(10),            /*原产地                                 */
fia09       varchar2(10),            /*供应商                                 */
fia10       varchar2(10),            /*负责人                                 */
fia11       varchar2(10),            /*负责部门                               */
fia12       varchar2(10),            /*维修合约                               */
fia13       number(5),               /*优先级                                 */
fia14       varchar2(20),            /*位置                                   */
fia15       varchar2(20),            /*子位置1                                */
fia16       varchar2(20),            /*子位置2                                */
fia17       varchar2(20),            /*子位置3                                */
fia18       date,                    /*购买日期                               */
fia19       date,                    /*启动日期                               */
fia20       date,                    /*担保终止日期                           */
fia21       varchar2(1),             /*开立新工单时通知否                     */
fia22       varchar2(255),           /*备注                                   */
fia23       number(20,6),            /*材料成本                               */
fia24       number(20,6),            /*劳工成本                               */
fia25       varchar2(300),           /*安全说明                               */
fia40       varchar2(1),             /*No                                     */
fia41       varchar2(1),             /*No                                     */
fia42       varchar2(1),             /*No                                     */
fia43       varchar2(1),             /*No                                     */
fiaacti     varchar2(1),             /*资料有效码                             */
fiauser     varchar2(10),            /*资料所有者                             */
fiagrup     varchar2(10),            /*资料所有部门                           */
fiamodu     varchar2(10),            /*最后更改人员                           */
fiadate     date,                    /*最后更改日期                           */
fiaud01     varchar2(255),           /*自订字段-Textedit                      */
fiaud02     varchar2(40),            /*自订字段-文字                          */
fiaud03     varchar2(40),            /*自订字段-文字                          */
fiaud04     varchar2(40),            /*自订字段-文字                          */
fiaud05     varchar2(40),            /*自订字段-文字                          */
fiaud06     varchar2(40),            /*自订字段-文字                          */
fiaud07     number(15,3),            /*自订字段-数值                          */
fiaud08     number(15,3),            /*自订字段-数值                          */
fiaud09     number(15,3),            /*自订字段-数值                          */
fiaud10     number(10),              /*自订字段-整数                          */
fiaud11     number(10),              /*自订字段-整数                          */
fiaud12     number(10),              /*自订字段-整数                          */
fiaud13     date,                    /*自订字段-日期                          */
fiaud14     date,                    /*自订字段-日期                          */
fiaud15     date,                    /*自订字段-日期                          */
fiaoriu     varchar2(10),            /*资料建立者                             */
fiaorig     varchar2(10)             /*资料建立部门                           */
);

alter table fia_file add  constraint fia_pk primary key  (fia01) enable validate;
grant select on fia_file to tiptopgp;
grant update on fia_file to tiptopgp;
grant delete on fia_file to tiptopgp;
grant insert on fia_file to tiptopgp;
grant index on fia_file to public;
grant select on fia_file to ods;
