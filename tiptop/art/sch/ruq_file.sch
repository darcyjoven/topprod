/*
================================================================================
檔案代號:ruq_file
檔案名稱:借出/还入单单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table ruq_file
(
ruq00       varchar2(1) DEFAULT ' ' NOT NULL, /*单据别 1-借出单,2-还入单*/
                                     /*Doc Type 1-Lending Note 2-Return Note  */
ruq01       varchar2(20) DEFAULT ' ' NOT NULL, /*借出/还入单号*/
ruq02       varchar2(20),            /*借出单号(只有单据别为2-还入            */
ruq03       date,                    /*借出/还入日期                          */
ruq04       varchar2(20),            /*押金收取/返还单号                      */
ruq05       varchar2(10),            /*经办人员                               */
ruq06       varchar2(10),            /*顾客姓名                               */
ruq07       varchar2(20),            /*顾客电话                               */
ruq08       varchar2(1) DEFAULT ' ' NOT NULL, /*证件类型*/
ruq09       varchar2(20),            /*证件号码                               */
ruq10       varchar2(255),           /*備注                                   */
ruq11       varchar2(10),            /*客户编号                               */
ruq12       varchar2(1),             /*过账否 Y-已过账N-未过账                */
ruqacti     varchar2(1) DEFAULT 'Y' NOT NULL, /*资料有效码*/
ruqcond     date,                    /*审核日期                               */
ruqconf     varchar2(1) DEFAULT 'N' NOT NULL, /*审核码*/
ruqconu     varchar2(10),            /*审核人员                               */
ruqcrat     date,                    /*资料创建日                             */
ruqdate     date,                    /*最近更改日                             */
ruqgrup     varchar2(10),            /*资料所有部门                           */
ruqlegal    varchar2(10) NOT NULL,   /*所属法人                               */
ruqmodu     varchar2(10),            /*资料更改者                             */
ruqorig     varchar2(10),            /*资料建立部门                           */
ruqoriu     varchar2(10),            /*资料建立者                             */
ruqplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
ruquser     varchar2(10)             /*资料所有者                             */
);

alter table ruq_file add  constraint ruq_pk primary key  (ruq00,ruq01) enable validate;
grant select on ruq_file to tiptopgp;
grant update on ruq_file to tiptopgp;
grant delete on ruq_file to tiptopgp;
grant insert on ruq_file to tiptopgp;
grant index on ruq_file to public;
grant select on ruq_file to ods;
