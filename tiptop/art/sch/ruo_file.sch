/*
================================================================================
檔案代號:ruo_file
檔案名稱:产品调拨单单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table ruo_file
(
ruo01       varchar2(20) DEFAULT ' ' NOT NULL, /*产品中心调拨单号*/
ruo02       varchar2(1),             /*来源类型                               */
                                     /*Source Category 1.By hand 2.require 3.fen shop*/
ruo03       varchar2(20),            /*来源单号                               */
ruo04       varchar2(10),            /*拨出营运中心                           */
ruo05       varchar2(10),            /*拨入营运中心                           */
ruo06       varchar2(10),            /*no use                                 */
ruo07       date,                    /*调拨日期                               */
ruo08       varchar2(10),            /*调拨人员                               */
ruo09       varchar2(255),           /*備注                                   */
ruo10       date,                    /*拨出审核日期                           */
ruo10t      varchar2(8),             /*拨出审核时间                           */
ruo11       varchar2(10),            /*拨出审核人员                           */
ruo12       date,                    /*拨入审核日期                           */
ruo12t      varchar2(8),             /*拨入审核时间                           */
ruo13       varchar2(10),            /*拨入审核人员                           */
ruoacti     varchar2(1),             /*资料有效码                             */
ruoconf     varchar2(1),             /*审核码                                 */
                                     /*Approval Code 0.open 1.out_confirm 2.in_confirm*/
ruocrat     date,                    /*资料创建日                             */
ruodate     date,                    /*最近更改日                             */
ruogrup     varchar2(10),            /*资料所有部门                           */
ruolegal    varchar2(10) NOT NULL,   /*所属法人                               */
ruomodu     varchar2(10),            /*资料更改者                             */
ruoplant    varchar2(10) DEFAULT ' ' NOT NULL, /*所属营运中心*/
ruouser     varchar2(10),            /*资料所有者                             */
ruopos      varchar2(1) DEFAULT '1' NOT NULL, /*已传POS否*/
ruooriu     varchar2(10),            /*资料建立者                             */
ruoorig     varchar2(10),            /*资料建立部门                           */
ruo14       varchar2(10),            /*在途仓库                               */
ruo15       varchar2(1),             /*当前营运中心过账否                     */
ruo901      varchar2(1),             /*多角贸易否                             */
ruo904      varchar2(8),             /*多角贸易流程代码                       */
ruo99       varchar2(17),            /*多角贸易流程序号                       */
ruo011      varchar2(20)             /*对应调拨单号                           */
);

alter table ruo_file add  constraint ruo_pk primary key  (ruo01,ruoplant) enable validate;
grant select on ruo_file to tiptopgp;
grant update on ruo_file to tiptopgp;
grant delete on ruo_file to tiptopgp;
grant insert on ruo_file to tiptopgp;
grant index on ruo_file to public;
grant select on ruo_file to ods;
