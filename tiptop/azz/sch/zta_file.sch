/*
================================================================================
檔案代號:zta_file
檔案名稱:档案名称档
檔案目的:
上游檔案:
下游檔案:
檔案類型:Z
多語系檔案:N
============.========================.==========================================
*/
create table zta_file
(
zta01       varchar2(15) NOT NULL,   /*档案代码                               */
                                     /*Table #, (Table name)                  */
                                     /*Ex:ima_file, zz_file                   */
zta02       varchar2(20) NOT NULL,   /*档案名称                               */
                                     /*no use                                 */
zta03       varchar2(3),             /*系统                                   */
zta04       varchar2(4),             /*使用别                                 */
zta05       date,                    /*生成日期                               */
zta06       varchar2(10),            /*生成者                                 */
zta07       varchar2(1),             /*T/S建议 (Table/Synonym)                */
zta08       varchar2(1),             /*No Use                                 */
zta09       varchar2(2),             /*档案类型                               */
                                     /*檔案類別(P/M/T/S)                      */
                                     /*P:參數檔                               */
                                     /*M:主檔   (M0:單頭 M1:單身)             */
                                     /*T:異動檔 (T0:單頭 T1:單身)             */
                                     /*S:統計檔                               */
zta10       varchar2(1),             /*数据库                                 */
zta11       varchar2(80),            /*档案名称                               */
                                     /*上游檔案                               */
zta12       varchar2(60),            /*档案目的                               */
                                     /*下游檔案                               */
zta13       varchar2(1),             /*档案来源                               */
                                     /*no use                                 */
zta14       varchar2(1),             /*上游档案                               */
                                     /*no use                                 */
zta15       varchar2(1),             /*下游档案                               */
                                     /*no use                                 */
zta16       varchar2(1),             /*注意事项                               */
                                     /*no use                                 */
zta17       varchar2(10),            /*Synonym DB                             */
zta18       varchar2(1) DEFAULT 'N' NOT NULL /*多語系檔案*/
);

alter table zta_file add  constraint zta_pk primary key  (zta01,zta02) enable validate;
grant select on zta_file to tiptopgp;
grant update on zta_file to tiptopgp;
grant delete on zta_file to tiptopgp;
grant insert on zta_file to tiptopgp;
grant index on zta_file to public;
grant select on zta_file to ods;
