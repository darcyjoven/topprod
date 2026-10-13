/*
================================================================================
檔案代號:fah_file
檔案名稱:固定资产系统单据性质档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table fah_file
(
fahslip     varchar2(5) NOT NULL,    /*单别                                   */
fahdesc     varchar2(80),            /*单据名称                               */
fahauno     varchar2(1),             /*自动编号否                             */
fahmxno     varchar2(20),            /*已用单号                               */
fahdmy3     varchar2(1),             /*抛转凭证                               */
fahdmy5     varchar2(1),             /*No Use                                 */
fahtype     varchar2(2),             /*单据性质                               */
fahprt      varchar2(1),             /*立即打印否                             */
fahconf     varchar2(1),             /*直接审核否                             */
fahpost     varchar2(1),             /*直接过帐否                             */
fah11       varchar2(24),            /*缺省对方会计科目                       */
fahapr      varchar2(1),             /*需签核                                 */
fahglcr     varchar2(1),             /*是否直接抛转总帐                       */
fahgslp     varchar2(5),             /*总帐单别                               */
fahgslp1    varchar2(5),             /*总帐第二单别                           */
fahfa1      varchar2(1) DEFAULT 'N' NOT NULL, /*财签*/
fahfa2      varchar2(1) DEFAULT 'N' NOT NULL, /*财签二*/
fahdmy32    varchar2(1) DEFAULT 'N' NOT NULL /*抛转凭证(财签二)*/
);

alter table fah_file add  constraint fah_pk primary key  (fahslip) enable validate;
grant select on fah_file to tiptopgp;
grant update on fah_file to tiptopgp;
grant delete on fah_file to tiptopgp;
grant insert on fah_file to tiptopgp;
grant index on fah_file to public;
grant select on fah_file to ods;
