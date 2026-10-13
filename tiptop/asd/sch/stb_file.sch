/*
================================================================================
檔案代號:stb_file
檔案名稱:标准成本明细档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table stb_file
(
stb01       varchar2(40) NOT NULL,   /*料号                                   */
                                     /*料號                                   */
stb02       number(5) NOT NULL,      /*年度                                   */
stb03       number(5) NOT NULL,      /*月份                                   */
stb04       number(20,6),            /*本阶直接材料成本                       */
                                     /*本階直接材料成本                       */
stb05       number(20,6),            /*本阶直接人工                           */
                                     /*本階直接人工                           */
stb06       number(20,6),            /*本阶间接制造费用                       */
                                     /*本階間接製造費用                       */
stb06a      number(20,6),            /*本阶其他制造费用                       */
                                     /*本階其他製造費用                       */
stb07       number(20,6),            /*累计直接材料成本                       */
                                     /*累計直接材料成本(含本階)               */
stb08       number(20,6),            /*累计直接人工                           */
                                     /*累計直接人工(含本階)                   */
stb09       number(20,6),            /*累计间接制造费用                       */
                                     /*累計間接製造費用(含本階)               */
stb09a      number(20,6),            /*累计其他制造费用                       */
                                     /*累計其他製造費用(含本階)               */
stb10       number(20,6)             /*实际成本                               */
                                     /*實際成本                               */
);

alter table stb_file add  constraint stb_pk primary key  (stb01,stb02,stb03) enable validate;
grant select on stb_file to tiptopgp;
grant update on stb_file to tiptopgp;
grant delete on stb_file to tiptopgp;
grant insert on stb_file to tiptopgp;
grant index on stb_file to public;
grant select on stb_file to ods;
