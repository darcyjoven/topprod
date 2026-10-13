/*
================================================================================
檔案代號:stp_file
檔案名稱:LCM明细档
檔案目的:
上游檔案:
下游檔案:
檔案類型:S
多語系檔案:N
============.========================.==========================================
*/
create table stp_file
(
stp01       varchar2(1),             /*类型                                   */
                                     /*類別: 4:在製品                         */
stp02       varchar2(40) NOT NULL,   /*料件编号                               */
                                     /*料件編號                               */
stp021      varchar2(10),            /*产品别                                 */
                                     /*產品別                                 */
stp03       number(15,3),            /*期末数量                               */
                                     /*期末數量                               */
stp04       number(20,6),            /*标准单价                               */
                                     /*標準單價                               */
stp05       number(20,6),            /*标准成本                               */
                                     /*標準成本                               */
stp06       number(20,6),            /*差异分配                               */
                                     /*差異分配                               */
stp07       number(20,6),            /*成品单位售价                           */
                                     /*成品單位售價                           */
stp08       number(20,6),            /*净变现价值                             */
                                     /*淨變現價值                             */
stp09       varchar2(20),            /*参考单据号码                           */
                                     /*參考單據號碼                           */
stp10       number(5),               /*参考单据项次                           */
                                     /*參考單據項次                           */
stp11       date,                    /*参考单据日期                           */
                                     /*參考單據日期                           */
stp12       varchar2(4),             /*币种                                   */
                                     /*幣別                                   */
stp13       number(20,6),            /*原币单价                               */
                                     /*原幣單價                               */
stp14       number(20,10),           /*汇率                                   */
                                     /*匯率                                   */
stp15       number(20,6),            /*LCM 成本                               */
stpplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
stplegal    varchar2(10) NOT NULL    /*所属法人                               */
);

alter table stp_file add  constraint stp_pk primary key  (stp02) enable validate;
grant select on stp_file to tiptopgp;
grant update on stp_file to tiptopgp;
grant delete on stp_file to tiptopgp;
grant insert on stp_file to tiptopgp;
grant index on stp_file to public;
grant select on stp_file to ods;
