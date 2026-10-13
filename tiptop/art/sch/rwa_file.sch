/*
================================================================================
檔案代號:rwa_file
檔案名稱:档期活动代码档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table rwa_file
(
rwa01       varchar2(10) DEFAULT ' ' NOT NULL, /*制定營運中心*/
rwa02       varchar2(20) DEFAULT ' ' NOT NULL, /*活动代码*/
rwa03       varchar2(10),            /*活动简称                               */
rwa04       varchar2(80),            /*活动名称                               */
rwa05       date,                    /*活动起始日期                           */
rwa06       date,                    /*活动截止日期                           */
rwa07       varchar2(10),            /*促销优先级 1.商品特价 2.品类           */
rwa08       varchar2(255),           /*备注                                   */
rwaacti     varchar2(1),             /*资料有效码                             */
rwacond     date,                    /*审核日期                               */
rwaconf     varchar2(1),             /*审核码 Y-审核,N-未审核 X-作废          */
rwaconu     varchar2(10),            /*审核人员                               */
rwacrat     date,                    /*资料创建日                             */
rwadate     date,                    /*最近更改日                             */
rwagrup     varchar2(10),            /*资料所有部门                           */
rwamodu     varchar2(10),            /*资料更改者                             */
rwauser     varchar2(10),            /*资料所有者                             */
rwaorig     varchar2(10),            /*资料建立部门                           */
rwaoriu     varchar2(10)             /*资料建立者                             */
);

alter table rwa_file add  constraint rwa_pk primary key  (rwa01,rwa02) enable validate;
grant select on rwa_file to tiptopgp;
grant update on rwa_file to tiptopgp;
grant delete on rwa_file to tiptopgp;
grant insert on rwa_file to tiptopgp;
grant index on rwa_file to public;
grant select on rwa_file to ods;
