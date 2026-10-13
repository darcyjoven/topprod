/*
================================================================================
檔案代號:vao_file
檔案名稱:aps物料清單/料表
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table vao_file
(
vao01       varchar2(40) DEFAULT ' ' NOT NULL, /*主件编号*/
vao02       varchar2(40) DEFAULT ' ' NOT NULL, /*元件编号*/
vao03       number(5) DEFAULT '0' NOT NULL, /*元件序号*/
vao04       number(16,8),            /*产出量                                 */
vao05       number(16,8),            /*元件投入量                             */
vao06       date,                    /*生效日                                 */
vao07       date,                    /*失效日                                 */
vao08       number(1),               /*元件替代码                             */
vao09       number(1),               /*元件替代优先顺序                       */
vao10       number(1),               /*元件群组替代码                         */
vao11       number(1),               /*是否耗尽料                             */
vao12       number(9,4),             /*损耗率                                 */
vao13       number(1),               /*替代方式                               */
vao14       number(1),               /*展元件需求                             */
vao15       number(1),               /*是否为客供料                           */
vao16       number(1),               /*是否考虑替代料单据供给                 */
vao17       number(1),               /*新单开立方式                           */
vao18       number(18,8),            /*替代比率                               */
vao19       number(5),               /*工艺路线序号                           */
vao20       varchar2(6),             /*作业编号                               */
vao21       number(1),               /*BOM表工单开立选项                      */
vao22       varchar2(60),            /*APS保留字段文字                        */
vao23       varchar2(60),            /*APS保留字段文字                        */
vao24       varchar2(60),            /*APS保留字段文字                        */
vao25       number(9),               /*APS保留字段数值                        */
vao26       number(18,8),            /*APS保留字段浮点数                      */
vao27       number(18,8),            /*APS保留字段浮点数                      */
vao28       date,                    /*APS保留字段日期                        */
vao29       date,                    /*APS保留字段日期                        */
vaolegal    varchar2(10) DEFAULT ' ' NOT NULL, /*所属法人*/
vaoplant    varchar2(10) DEFAULT ' ' NOT NULL /*所属工厂*/
);

alter table vao_file add  constraint vao_pk primary key  (vaolegal,vaoplant,vao01,vao02,vao03) enable validate;
grant select on vao_file to tiptopgp;
grant update on vao_file to tiptopgp;
grant delete on vao_file to tiptopgp;
grant insert on vao_file to tiptopgp;
grant index on vao_file to public;
grant select on vao_file to ods;
