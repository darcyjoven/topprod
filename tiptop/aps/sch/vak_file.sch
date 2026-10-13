/*
================================================================================
檔案代號:vak_file
檔案名稱:aps料件供應商
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table vak_file
(
vak01       varchar2(40) DEFAULT ' ' NOT NULL, /*料号*/
vak02       varchar2(10) DEFAULT ' ' NOT NULL, /*供应商编号*/
vak03       number(15,3),            /*采购倍量                               */
vak04       varchar2(60),            /*库房位置                               */
vak05       number(18,8),            /*最大采购量                             */
vak06       number(15,3),            /*最小采购量                             */
vak07       varchar2(4),             /*单位                                   */
vak08       number(15,3),            /*检验时间                               */
vak09       number(18,8),            /*固定采购前置时间                       */
vak10       number(18,8),            /*变动采购前置时间                       */
vak11       number(18,8),            /*变动天数的基本数量                     */
vak12       number(1),               /*合并尾批                               */
vak13       number(18,8),            /*并单之判断比率                         */
vak14       number(20,8),            /*转换比率                               */
vak15       number(1),               /*批量开立规则                           */
vak16       number(18,8),            /*关键料软性前置时间                     */
vak17       number(18,8),            /*关键料软性变动前置时间                 */
vak18       number(9,4),             /*供应商开立比例                         */
vak19       varchar2(1) DEFAULT '1' NOT NULL, /*供货商型态 (1采购, 2委外)*/
vak20       varchar2(60),            /*APS保留字段文字                        */
vak21       varchar2(60),            /*APS保留字段文字                        */
vak22       varchar2(60),            /*APS保留字段文字                        */
vak23       number(9),               /*APS保留字段数值                        */
vak24       number(18,8),            /*APS保留字段浮点数                      */
vak25       number(18,8),            /*APS保留字段浮点数                      */
vak26       date,                    /*APS保留字段日期                        */
vak27       date,                    /*APS保留字段日期                        */
vaklegal    varchar2(10) DEFAULT ' ' NOT NULL, /*所属法人*/
vakplant    varchar2(10) DEFAULT ' ' NOT NULL, /*所属工厂*/
vak28       varchar2(60),            /*供应商名称                             */
vak29       number(18,8),            /*最少采购数量                           */
vak30       number(18,8)             /*采购单位批量                           */
);

alter table vak_file add  constraint vak_pk primary key  (vaklegal,vakplant,vak01,vak02,vak19) enable validate;
grant select on vak_file to tiptopgp;
grant update on vak_file to tiptopgp;
grant delete on vak_file to tiptopgp;
grant insert on vak_file to tiptopgp;
grant index on vak_file to public;
grant select on vak_file to ods;
