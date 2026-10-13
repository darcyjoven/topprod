/*
================================================================================
檔案代號:bgv_file
檔案名稱:部门用人费用项目档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table bgv_file
(
bgv00       varchar2(1) NOT NULL,    /*费用别                                 */
                                     /*費用別1:用人費用 2.非用人費用 2003/10/16*/
bgv01       varchar2(10) NOT NULL,   /*版本                                   */
bgv02       number(5) NOT NULL,      /*年度                                   */
bgv03       number(5) NOT NULL,      /*月份                                   */
bgv04       varchar2(10) NOT NULL,   /*部门编号                               */
                                     /*部門編號                               */
bgv05       varchar2(6) NOT NULL,    /*费用项目                               */
                                     /*費用項目                               */
bgv06       varchar2(1) NOT NULL,    /*直间接                                 */
                                     /*直間接  1.直接 2.間接                  */
bgv07       varchar2(10) NOT NULL,   /*职等编号                               */
                                     /*職等代號                               */
bgv08       number(5) NOT NULL,      /*职级编号                               */
                                     /*職級代號                               */
bgv09       varchar2(80),            /*职称说明                               */
                                     /*職稱說明                               */
bgv10       number(20,6),            /*平均金额                               */
                                     /*平均金額                               */
bgv11       varchar2(15),            /*细部分类                               */
                                     /*細部分類   2003/10/16                  */
bgvuser     varchar2(10),            /*资料所有者                             */
bgvgrup     varchar2(10),            /*资料所有群                             */
bgvmodu     varchar2(10),            /*资料更改者                             */
bgvdate     date,                    /*最近更改日                             */
bgvorig     varchar2(10),            /*资料建立部门                           */
bgvoriu     varchar2(10)             /*资料建立者                             */
);

alter table bgv_file add  constraint bgv_pk primary key  (bgv00,bgv01,bgv02,bgv03,bgv04,bgv05,bgv06,bgv07,bgv08) enable validate;
grant select on bgv_file to tiptopgp;
grant update on bgv_file to tiptopgp;
grant delete on bgv_file to tiptopgp;
grant insert on bgv_file to tiptopgp;
grant index on bgv_file to public;
grant select on bgv_file to ods;
