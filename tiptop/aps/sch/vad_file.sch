/*
================================================================================
檔案代號:vad_file
檔案名稱:aps資源
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table vad_file
(
vad01       varchar2(10) DEFAULT ' ' NOT NULL, /*资源编号*/
vad02       varchar2(60),            /*周行事历                               */
vad03       varchar2(60),            /*日行事历                               */
vad04       number(1),               /*产能类型                               */
vad05       varchar2(40),            /*设备名称                               */
vad06       varchar2(40),            /*资源描述                               */
vad07       number(1),               /*连批条件检查码                         */
vad08       number(9,4),             /*效率                                   */
vad09       varchar2(10),            /*工作站编号                             */
vad10       varchar2(60),            /*规格一                                 */
vad11       varchar2(60),            /*规格二                                 */
vad12       varchar2(60),            /*规格三                                 */
vad13       varchar2(60),            /*规格四                                 */
vad14       varchar2(60),            /*规格五                                 */
vad15       varchar2(60),            /*APS保留字段文字                        */
vad16       varchar2(60),            /*APS保留字段文字                        */
vad17       varchar2(60),            /*APS保留字段文字                        */
vad18       number(9),               /*APS保留字段数值                        */
vad19       number(18,8),            /*APS保留字段浮点数                      */
vad20       number(18,8),            /*APS保留字段浮点数                      */
vad21       date,                    /*APS保留字段日期                        */
vad22       date,                    /*APS保留字段日期                        */
vadlegal    varchar2(10) DEFAULT ' ' NOT NULL, /*所属法人*/
vadplant    varchar2(10) DEFAULT ' ' NOT NULL /*所属工厂*/
);

alter table vad_file add  constraint vad_pk primary key  (vadlegal,vadplant,vad01) enable validate;
grant select on vad_file to tiptopgp;
grant update on vad_file to tiptopgp;
grant delete on vad_file to tiptopgp;
grant insert on vad_file to tiptopgp;
grant index on vad_file to public;
grant select on vad_file to ods;
