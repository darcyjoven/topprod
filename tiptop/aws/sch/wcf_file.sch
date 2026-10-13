/*
================================================================================
檔案代號:wcf_file
檔案名稱:PLM整合资料暂存档
檔案目的:
上游檔案:
下游檔案:N
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table wcf_file
(
wcf01       varchar2(17) DEFAULT ' ' NOT NULL, /*主键值*/
wcf02       date DEFAULT sysdate NOT NULL, /*XML接收日期*/
wcf03       varchar2(12) DEFAULT ' ' NOT NULL, /*XML接收时间*/
wcf06       varchar2(20) DEFAULT ' ' NOT NULL, /*DataKey*/
wcf07       number(5),               /*Total Count                            */
wcf08       number(5),               /*Sub Count                              */
wcf09       varchar2(40) DEFAULT ' ' NOT NULL, /*TP端实际处理的服务名称*/
wcf10       clob NOT NULL,           /*PLM传入的完整XML                       */
wcf11       varchar2(6),             /*PLM传入的XML语系                       */
wcf12       varchar2(8),             /*回馈批处理结果代码(Status Code)        */
wcf13       varchar2(8),             /*回馈批处理结果代码(SQL Code)           */
wcf14       clob,                    /*回馈批处理结果说明                     */
wcf15       date,                    /*回馈批处理结果日期                     */
wcf16       varchar2(12),            /*回馈批处理结果时间                     */
wcf17       varchar2(1) DEFAULT ' ' NOT NULL, /*数据处理码*/
wcf18       varchar2(20),            /*纪录TIPTOP单据单号                     */
wcflegal    varchar2(10) DEFAULT ' ' NOT NULL, /*所属法人*/
wcfplant    varchar2(10) DEFAULT ' ' NOT NULL /*所属营运中心*/
);

create        index wcf_01 on wcf_file (wcf01,wcf02);
create        index wcf_02 on wcf_file (wcf02,wcf06);
create        index wcf_06 on wcf_file (wcf06);
alter table wcf_file add  constraint wcf_pk primary key  (wcf01) enable validate;
grant select on wcf_file to tiptopgp;
grant update on wcf_file to tiptopgp;
grant delete on wcf_file to tiptopgp;
grant insert on wcf_file to tiptopgp;
grant index on wcf_file to public;
grant select on wcf_file to ods;
