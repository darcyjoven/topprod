/*
================================================================================
檔案代號:vlf_file
檔案名稱:mds沖銷關聯檔
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table vlf_file
(
vlf01       varchar2(10) NOT NULL,   /*aps版本                                */
vlf02       varchar2(10) NOT NULL,   /*储存版本                               */
vlf03       varchar2(40) NOT NULL,   /*料号                                   */
vlf04       date NOT NULL,           /*归属时距日                             */
vlf05       number(5) NOT NULL,      /*序号                                   */
vlf06       varchar2(1),             /*需求纳入方式                           */
vlf07       number(15,3),            /*时距内总需求量                         */
vlf08       varchar2(1),             /*no use                                 */
vlf09       varchar2(1),             /*no use                                 */
vlf10       varchar2(20),            /*订单编号                               */
vlf11       number(5),               /*项次                                   */
vlf12       date,                    /*单据日期                               */
vlf13       varchar2(1),             /*来源型式                               */
vlf14       varchar2(1),             /*no use                                 */
vlf15       varchar2(40),            /*实际料号                               */
vlf16       varchar2(60),            /*需求单号                               */
vlf17       date,                    /*需求日期                               */
vlf18       number(15,3),            /*冲销量                                 */
vlf19       varchar2(1),             /*冲销状况                               */
vlf20       varchar2(20),            /*预测                                   */
vlf21       varchar2(10),            /*客户编号                               */
vlf22       date,                    /*计划日期                               */
vlf23       varchar2(10),            /*业务员                                 */
vlf24       number(5),               /*序号                                   */
vlf25       varchar2(40),            /*实际料号                               */
vlf26       varchar2(60),            /*需求单号                               */
vlf27       date,                    /*需求日期                               */
vlf28       number(15,3),            /*冲销量                                 */
vlf29       varchar2(1),             /*冲销状况                               */
vlfplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
vlflegal    varchar2(10) NOT NULL    /*所属法人                               */
);

alter table vlf_file add  constraint vlf_pk primary key  (vlf01,vlf02,vlf03,vlf04,vlf05) enable validate;
grant select on vlf_file to tiptopgp;
grant update on vlf_file to tiptopgp;
grant delete on vlf_file to tiptopgp;
grant insert on vlf_file to tiptopgp;
grant index on vlf_file to public;
grant select on vlf_file to ods;
