/*
================================================================================
檔案代號:raa_file
檔案名稱:档期活动资料表
檔案目的:
上游檔案:
下游檔案:
檔案類型:Z
多語系檔案:N
============.========================.==========================================
*/
create table raa_file
(
raa01       varchar2(10) DEFAULT ' ' NOT NULL, /*制定机构*/
raa02       varchar2(20) DEFAULT ' ' NOT NULL, /*活动代码*/
raa03       varchar2(10),            /*活动简称                               */
raa04       varchar2(80),            /*活动名称                               */
raa05       date,                    /*活动起始日期                           */
raa06       date,                    /*活动截止日期                           */
raa07       varchar2(10),            /*促销优先级 1.一般促销 2.组合           */
raa08       varchar2(255),           /*备注                                   */
raaacti     varchar2(1) DEFAULT ' ' NOT NULL, /*资料有效码*/
raacond     date,                    /*审核日期                               */
raaconf     varchar2(1) DEFAULT 'N' NOT NULL, /*审核码 Y-已审核 N-未审核 X-已 */
raaconu     varchar2(10),            /*审核人员                               */
raacrat     date,                    /*资料创建日                             */
raadate     date,                    /*最近更改日                             */
raagrup     varchar2(10),            /*资料所有部门                           */
raamodu     varchar2(10),            /*资料更改者                             */
raaorig     varchar2(10),            /*资料建立部门                           */
raaoriu     varchar2(10),            /*资料建立者                             */
raauser     varchar2(10)             /*资料所有者                             */
);

alter table raa_file add  constraint raa_pk primary key  (raa01,raa02) enable validate;
grant select on raa_file to tiptopgp;
grant update on raa_file to tiptopgp;
grant delete on raa_file to tiptopgp;
grant insert on raa_file to tiptopgp;
grant index on raa_file to public;
grant select on raa_file to ods;
