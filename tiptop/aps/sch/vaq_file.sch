/*
================================================================================
檔案代號:vaq_file
檔案名稱:aps單品取替代
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table vaq_file
(
vaq01       varchar2(40) DEFAULT ' ' NOT NULL, /*主件料号*/
vaq02       varchar2(40) DEFAULT ' ' NOT NULL, /*元件料号*/
vaq03       varchar2(40) DEFAULT ' ' NOT NULL, /*取替代料料号*/
vaq04       number(5),               /*取替代优先顺序                         */
vaq05       number(15,3),            /*投入量                                 */
vaq06       date,                    /*生效日                                 */
vaq07       date,                    /*失效日                                 */
vaq08       number(18,8),            /*产出量                                 */
vaq09       number(9,4),             /*元件损耗率                             */
vaq10       number(1),               /*取替代属性                             */
vaq11       number(18,8),            /*以bom为主设置的替代比率                */
vaq12       varchar2(60),            /*APS保留字段文字                        */
vaq13       varchar2(60),            /*APS保留字段文字                        */
vaq14       varchar2(60),            /*APS保留字段文字                        */
vaq15       number(9),               /*APS保留字段数值                        */
vaq16       number(18,8),            /*APS保留字段浮点数                      */
vaq17       number(18,8),            /*APS保留字段浮点数                      */
vaq18       date,                    /*APS保留字段日期                        */
vaq19       date,                    /*APS保留字段日期                        */
vaqlegal    varchar2(10) DEFAULT ' ' NOT NULL, /*所属法人*/
vaqplant    varchar2(10) DEFAULT ' ' NOT NULL /*所属工厂*/
);

alter table vaq_file add  constraint vaq_pk primary key  (vaqlegal,vaqplant,vaq01,vaq02,vaq03) enable validate;
grant select on vaq_file to tiptopgp;
grant update on vaq_file to tiptopgp;
grant delete on vaq_file to tiptopgp;
grant insert on vaq_file to tiptopgp;
grant index on vaq_file to public;
grant select on vaq_file to ods;
