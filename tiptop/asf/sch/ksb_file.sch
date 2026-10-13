/*
================================================================================
檔案代號:ksb_file
檔案名稱:拆件式工单 FQC 单身资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table ksb_file
(
ksb01       varchar2(20) NOT NULL,   /*FQC 单号                               */
                                     /*FQC 單號                               */
ksb02       varchar2(20),            /*拆件式工单单号                         */
                                     /*拆件式工單單號                         */
ksb03       date,                    /*异动日期                               */
                                     /*異動日期                               */
ksb04       varchar2(40),            /*料号                                   */
                                     /*料號                                   */
ksb05       number(15,3),            /*FQC 送检数量                           */
                                     /*FQC 送檢數量                           */
ksb06       varchar2(4),             /*生产单位                               */
                                     /*生產單位                               */
ksb07       number(15,3),            /*在验数量                               */
                                     /*在驗數量                               */
ksb071      number(15,3),            /*入库数量                               */
                                     /*入庫數量                               */
ksb08       number(15,3),            /*验退数量                               */
                                     /*驗退數量                               */
ksb09       number(5),               /*作业序号                               */
                                     /*作業序號                               */
ksb10       varchar2(10),            /*工作站编号                             */
                                     /*工作站編號                             */
ksb11       varchar2(20),            /*异动指令                               */
                                     /*異動命令                               */
ksb12       varchar2(20),            /*箱号                                   */
                                     /*箱號                                   */
ksb13       number(5) NOT NULL,      /*序号                                   */
                                     /*序號                                   */
ksb14       varchar2(10),            /*仓库                                   */
                                     /*倉庫                                   */
ksb15       varchar2(10),            /*库位                                   */
                                     /*儲位                                   */
ksb16       varchar2(24),            /*批号                                   */
                                     /*批號                                   */
ksb70       varchar2(1),             /*No Use                                 */
ksb71       varchar2(1),             /*No Use                                 */
ksb80       number(5),               /*No Use                                 */
ksb81       number(5),               /*No Use                                 */
ksb82       number(5),               /*No Use                                 */
ksb83       number(5),               /*No Use                                 */
ksb84       number(5),               /*No Use                                 */
ksb85       number(5),               /*No Use                                 */
ksb86       number(5),               /*No Use                                 */
ksb87       number(5),               /*No Use                                 */
ksb88       number(5),               /*No Use                                 */
ksb89       number(5),               /*No Use                                 */
ksb90       number(5),               /*No Use                                 */
ksbplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
ksblegal    varchar2(10) NOT NULL    /*所属法人                               */
);

create        index ksb_02 on ksb_file (ksb02);
create        index ksb_03 on ksb_file (ksb04);
alter table ksb_file add  constraint ksb_pk primary key  (ksb01,ksb13) enable validate;
grant select on ksb_file to tiptopgp;
grant update on ksb_file to tiptopgp;
grant delete on ksb_file to tiptopgp;
grant insert on ksb_file to tiptopgp;
grant index on ksb_file to public;
grant select on ksb_file to ods;
