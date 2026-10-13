/*
================================================================================
檔案代號:ryl_file
檔案名稱:POS传输异常记录档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table ryl_file
(
ryl01       varchar2(20) DEFAULT ' ' NOT NULL, /*POS传输编号*/
ryl02       varchar2(10) DEFAULT ' ' NOT NULL, /*营运中心编号*/
ryl03       varchar2(20) DEFAULT ' ' NOT NULL, /*POS单据编号*/
ryl04       varchar2(4) DEFAULT ' ' NOT NULL, /*单据类型*/
ryl05       varchar2(15) DEFAULT ' ' NOT NULL, /*資料表名*/
ryl06       varchar2(20),            /*異常代碼                               */
ryl07       varchar2(255),           /*異常訊息                               */
ryl08       varchar2(1) DEFAULT ' ' NOT NULL, /*傳輸類型*/
ryl09       varchar2(1) DEFAULT 'N' NOT NULL, /*傳輸狀態*/
ryl10       date,                    /*傳輸日期                               */
ryl11       varchar2(8),             /*傳輸時間                               */
ryl12       varchar2(10),            /*傳輸操作者                             */
ryl13       varchar2(255),           /*備注                                   */
ryl14       varchar2(20),            /*und01                                  */
ryl15       varchar2(20),            /*und02                                  */
ryl16       varchar2(255)            /*und03                                  */
);

alter table ryl_file add  constraint ryl_pk primary key  (ryl01,ryl02,ryl03,ryl04,ryl05) enable validate;
grant select on ryl_file to tiptopgp;
grant update on ryl_file to tiptopgp;
grant delete on ryl_file to tiptopgp;
grant insert on ryl_file to tiptopgp;
grant index on ryl_file to public;
grant select on ryl_file to ods;
