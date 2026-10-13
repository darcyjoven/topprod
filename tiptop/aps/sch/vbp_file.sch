/*
================================================================================
檔案代號:vbp_file
檔案名稱:工艺BOM
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table vbp_file
(
vbp01       varchar2(40) DEFAULT ' ' NOT NULL, /*主件编号*/
vbp011      varchar2(10) DEFAULT ' ' NOT NULL, /*工艺编号*/
vbp012      varchar2(10) DEFAULT ' ' NOT NULL,
vbp013      varchar2(60) DEFAULT '0' NOT NULL, /*工艺序*/
vbp02       varchar2(40) DEFAULT ' ' NOT NULL, /*元件编号*/
vbp03       number(5) DEFAULT '0' NOT NULL, /*元件序号*/
vbp04       number(16,8),            /*产出量                                 */
vbp05       number(16,8),            /*元件投入量                             */
vbp06       date,                    /*生效日                                 */
vbp07       date,                    /*失效日                                 */
vbp08       number(1),               /*元件替代码                             */
vbp09       number(1),               /*元件替代优先顺序                       */
vbp10       number(1),               /*元件群组替代码                         */
vbp11       number(1),               /*是否为耗尽料                           */
vbp12       number(9,4),
vbp13       number(1),
vbp14       number(1),
vbp15       number(1),               /*是否为客供料                           */
vbp16       number(1),               /*是否考虑替代料单据供给                 */
vbp17       number(1),               /*新单开立方式                           */
vbp18       number(18,8),            /*替代比率                               */
vbp19       number(5),               /*工艺路线序号                           */
vbp20       varchar2(6),             /*作业编号                               */
vbp21       number(1),
vbp22       varchar2(60),            /*APS保留字段文字                        */
vbp23       varchar2(60),            /*APS保留字段文字                        */
vbp24       varchar2(60),            /*APS保留字段文字                        */
vbp25       number(9),               /*APS保留字段数值                        */
vbp26       number(18,8),            /*APS保留字段浮点数                      */
vbp27       number(18,8),            /*APS保留字段浮点数                      */
vbp28       date,                    /*APS保留字段日期                        */
vbp29       date,                    /*APS保留字段日期                        */
vbp30       number(15,3) DEFAULT '0' NOT NULL,
vbp31       number(9,4),             /*损耗批量                               */
vbplegal    varchar2(10) DEFAULT ' ' NOT NULL, /*所属法人*/
vbpplant    varchar2(10) DEFAULT ' ' NOT NULL /*所属营运中心*/
);

alter table vbp_file add  constraint vbp_pk primary key  (vbplegal,vbpplant,vbp01,vbp011,vbp012,vbp013,vbp02,vbp03) enable validate;
grant select on vbp_file to tiptopgp;
grant update on vbp_file to tiptopgp;
grant delete on vbp_file to tiptopgp;
grant insert on vbp_file to tiptopgp;
grant index on vbp_file to public;
grant select on vbp_file to ods;
