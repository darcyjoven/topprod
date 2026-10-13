/*
================================================================================
檔案代號:rcf_file
檔案名稱:竞争对手销售资料单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table rcf_file
(
rcf01       varchar2(20) DEFAULT ' ' NOT NULL, /*竞争对手销售单号*/
rcf02       date,                    /*销售日期                               */
rcf03       varchar2(255),           /*备注                                   */
rcfacti     varchar2(1) NOT NULL,    /*资料有效码                             */
rcfcond     date,                    /*审核日期                               */
rcfconf     varchar2(1) DEFAULT ' ' NOT NULL, /*审核否*/
rcfcont     varchar2(8),             /*审核时间                               */
rcfconu     varchar2(10),            /*审核人员                               */
rcfcrat     date,                    /*资料创建日                             */
rcfdate     date,                    /*最近更改日                             */
rcfgrup     varchar2(10),            /*资料所有群                             */
rcflegal    varchar2(10) DEFAULT ' ' NOT NULL, /*所属法人*/
rcfmodu     varchar2(10),            /*资料更改者                             */
rcforig     varchar2(10),            /*资料建立部门                           */
rcforiu     varchar2(10),            /*资料建立者                             */
rcfplant    varchar2(10) DEFAULT ' ' NOT NULL, /*所属工厂*/
rcfuser     varchar2(10)             /*资料所有者                             */
);

alter table rcf_file add  constraint rcf_pk primary key  (rcf01) enable validate;
grant select on rcf_file to tiptopgp;
grant update on rcf_file to tiptopgp;
grant delete on rcf_file to tiptopgp;
grant insert on rcf_file to tiptopgp;
grant index on rcf_file to public;
grant select on rcf_file to ods;
