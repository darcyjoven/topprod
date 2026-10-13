/*
================================================================================
檔案代號:stp1_file
檔案名稱:LCM      --半成品
檔案目的:
上游檔案:
下游檔案:
檔案類型:S
多語系檔案:N
============.========================.==========================================
*/
create table stp1_file
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
stp14       number(20,6),            /*汇率                                   */
                                     /*匯率                                   */
stp15       number(20,6),            /*LCM 成本                               */
stp16       varchar2(40),            /*成品料号                               */
                                     /*成品料號                               */
stp17       number(20,6),            /*成品标准成本                           */
                                     /*成品標準成本                           */
stp18       number(20,6),            /*制成品成本                             */
                                     /*製成品成本                             */
stp19       number(20,6),            /*预计投入成本                           */
                                     /*預計投入成本                           */
stp1plant   varchar2(10) NOT NULL,   /*所属营运中心                           */
stp1legal   varchar2(10) NOT NULL    /*所属法人                               */
);

alter table stp1_file add  constraint stp1_pk primary key  (stp02) enable validate;
grant select on stp1_file to tiptopgp;
grant update on stp1_file to tiptopgp;
grant delete on stp1_file to tiptopgp;
grant insert on stp1_file to tiptopgp;
grant index on stp1_file to public;
grant select on stp1_file to ods;
