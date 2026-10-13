/*
================================================================================
檔案代號:ibj_file
檔案名稱:条码扫描纪录暂存档
檔案目的:
上游檔案:
下游檔案:N
檔案類型:S
多語系檔案:N
============.========================.==========================================
*/
create table ibj_file
(
ibj01       varchar2(1) DEFAULT ' ' NOT NULL, /*扫描类型*/
ibj02       varchar2(80) DEFAULT ' ' NOT NULL, /*料件条码编号*/
ibj03       varchar2(10),            /*仓库                                   */
ibj04       varchar2(10),            /*库位                                   */
ibj05       number(15,3) DEFAULT '0' NOT NULL, /*异动数量*/
ibj06       varchar2(20),            /*来源单号                               */
ibj07       number(5),               /*来源项次                               */
ibj08       varchar2(20),            /*目的单号                               */
ibj09       number(5),               /*目的项次                               */
ibj10       varchar2(1) DEFAULT 'N' NOT NULL, /*处理否*/
ibj11       varchar2(20) DEFAULT ' ' NOT NULL, /*程序代码*/
ibj12       varchar2(20) DEFAULT ' ' NOT NULL, /*ProcessID*/
ibj13       varchar2(10) DEFAULT ' ' NOT NULL, /*使用者ID*/
ibj14       date DEFAULT sysdate NOT NULL, /*扫描日期*/
ibj15       varchar2(12) DEFAULT ' ' NOT NULL, /*扫描时间(时:分:秒.毫秒)*/
ibj16       varchar2(20) DEFAULT ' ' NOT NULL, /*伺服器编号*/
ibjgrup     varchar2(10),            /*资料所有群                             */
ibjlegal    varchar2(10) DEFAULT ' ' NOT NULL, /*所属法人*/
ibjplant    varchar2(10) DEFAULT ' ' NOT NULL, /*所属营运中心*/
ibjuser     varchar2(10),            /*资料所有者                             */
ibj17       number(5)                /*检验批号(分批检验顺序)                 */
);

grant select on ibj_file to tiptopgp;
grant update on ibj_file to tiptopgp;
grant delete on ibj_file to tiptopgp;
grant insert on ibj_file to tiptopgp;
grant index on ibj_file to public;
grant select on ibj_file to ods;
