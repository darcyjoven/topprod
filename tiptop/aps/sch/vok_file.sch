/*
================================================================================
檔案代號:vok_file
檔案名稱:aps(替代供給結果)
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table vok_file
(
vok00       varchar2(10) DEFAULT ' ' NOT NULL, /*营运中心*/
vok01       varchar2(10) DEFAULT ' ' NOT NULL, /*APS版本*/
vok02       varchar2(10) DEFAULT ' ' NOT NULL, /*储存版本*/
vok03       varchar2(40),            /*料号                                   */
vok04       varchar2(10),            /*厂商编号                               */
vok05       date,                    /*供需日期(实际-依时距)                  */
vok06       date,                    /*供需日期(实际)                         */
vok07       varchar2(60),            /*供需类型                               */
vok08       varchar2(60),            /*来源单号                               */
vok09       number(5),               /*来源项次                               */
vok10       number(1),               /*冻结交期否                             */
vok11       varchar2(40),            /*来源料号                               */
vok12       number(15,3),            /*数量                                   */
vok13       date,                    /*供需日期(规划-依时距)                  */
vok14       date,                    /*供需日期(规划)                         */
vok15       varchar2(60),            /*APS保留字段文字                        */
vok16       varchar2(60),            /*APS保留字段文字                        */
vok17       varchar2(60),            /*APS保留字段文字                        */
vok18       number(9),               /*APS保留字段数值                        */
vok19       number(18,8),            /*APS保留字段浮点数                      */
vok20       number(18,8),            /*APS保留字段浮点数                      */
vok21       date,                    /*APS保留字段日期                        */
vok22       date,                    /*APS保留字段日期                        */
voklegal    varchar2(10) DEFAULT ' ' NOT NULL, /*所属法人*/
vokplant    varchar2(10) DEFAULT ' ' NOT NULL /*所属工厂*/
);

grant select on vok_file to tiptopgp;
grant update on vok_file to tiptopgp;
grant delete on vok_file to tiptopgp;
grant insert on vok_file to tiptopgp;
grant index on vok_file to public;
grant select on vok_file to ods;
