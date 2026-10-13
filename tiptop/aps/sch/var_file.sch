/*
================================================================================
檔案代號:var_file
檔案名稱:aps(萬用取替代）
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table var_file
(
var01       varchar2(40) DEFAULT ' ' NOT NULL, /*元件编号*/
var02       varchar2(40) DEFAULT ' ' NOT NULL, /*取替代料品号*/
var03       number(5),               /*取替代优先顺序                         */
var04       number(15,3),            /*投入量                                 */
var05       date,                    /*生效日                                 */
var06       date,                    /*失效日                                 */
var07       number(18,8),            /*产出量                                 */
var08       number(9,4),             /*损耗率                                 */
var09       number(1),               /*取替代属性                             */
var10       number(18,8),            /*替代比率                               */
var11       varchar2(60),            /*APS保留字段文字                        */
var12       varchar2(60),            /*APS保留字段文字                        */
var13       varchar2(60),            /*APS保留字段文字                        */
var14       number(9),               /*APS保留字段数值                        */
var15       number(18,8),            /*APS保留字段浮点数                      */
var16       number(18,8),            /*APS保留字段浮点数                      */
var17       date,                    /*APS保留字段日期                        */
var18       date,                    /*APS保留字段日期                        */
varlegal    varchar2(10) DEFAULT ' ' NOT NULL, /*所属法人*/
varplant    varchar2(10) DEFAULT ' ' NOT NULL /*所属工厂*/
);

alter table var_file add  constraint var_pk primary key  (varlegal,varplant,var01,var02) enable validate;
grant select on var_file to tiptopgp;
grant update on var_file to tiptopgp;
grant delete on var_file to tiptopgp;
grant insert on var_file to tiptopgp;
grant index on var_file to public;
grant select on var_file to ods;
