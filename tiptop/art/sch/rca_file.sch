/*
================================================================================
檔案代號:rca_file
檔案名稱:专柜抽成资料单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table rca_file
(
rca01       varchar2(10) DEFAULT ' ' NOT NULL, /*营运中心编号*/
rca02       date DEFAULT sysdate NOT NULL, /*生效日期*/
rca03       date DEFAULT sysdate NOT NULL, /*失效日期*/
rca04       varchar2(1) DEFAULT ' ' NOT NULL, /*产品分群类型*/
rca05       varchar2(255),           /*备注                                   */
rcaacti     varchar2(1) NOT NULL,    /*资料有效码                             */
rcacond     date,                    /*审核日期                               */
rcaconf     varchar2(1) NOT NULL,    /*审核否                                 */
rcacont     varchar2(8),             /*审核时间                               */
rcaconu     varchar2(10),            /*审核人员                               */
rcacrat     date,                    /*资料创建日                             */
rcadate     date,                    /*最近更改日                             */
rcagrup     varchar2(10),            /*资料所有群                             */
rcamodu     varchar2(10),            /*资料更改者                             */
rcaorig     varchar2(10),            /*资料建立部门                           */
rcaoriu     varchar2(10),            /*资料建立者                             */
rcapos      varchar2(1) DEFAULT ' ' NOT NULL, /*已传POS状态*/
rcauser     varchar2(10)             /*资料所有者                             */
);

alter table rca_file add  constraint rca_pk primary key  (rca01,rca02,rca03) enable validate;
grant select on rca_file to tiptopgp;
grant update on rca_file to tiptopgp;
grant delete on rca_file to tiptopgp;
grant insert on rca_file to tiptopgp;
grant index on rca_file to public;
grant select on rca_file to ods;
