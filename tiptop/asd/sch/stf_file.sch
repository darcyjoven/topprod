/*
================================================================================
檔案代號:stf_file
檔案名稱:工单领退明细档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table stf_file
(
stf01       varchar2(1),             /*区分                                   */
                                     /*區分: 1.廠內工單  2.委外工單           */
stf02       number(5),               /*年度                                   */
stf03       number(5),               /*月份                                   */
stf04       varchar2(20),            /*工单号码                               */
                                     /*工單號碼                               */
stf05       varchar2(20),            /*领退料单号                             */
                                     /*領退料單號                             */
stf06       date,                    /*领退日期                               */
                                     /*領退日期                               */
stf07       varchar2(40),            /*领退料号                               */
                                     /*領退料號                               */
stf08       number(15,3),            /*数量                                   */
                                     /*數量(若為退料則數量為負數)             */
stf09       number(20,6),            /*单位标准成本                           */
                                     /*單位標準成本                           */
stf10       number(20,6),            /*标准成本                               */
                                     /*標準成本                               */
stf11       varchar2(10),            /*仓库                                   */
                                     /*倉庫                                   */
stfplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
stflegal    varchar2(10) NOT NULL    /*所属法人                               */
);

create        index stf_01 on stf_file (stf02,stf03,stf04,stf06);
grant select on stf_file to tiptopgp;
grant update on stf_file to tiptopgp;
grant delete on stf_file to tiptopgp;
grant insert on stf_file to tiptopgp;
grant index on stf_file to public;
grant select on stf_file to ods;
