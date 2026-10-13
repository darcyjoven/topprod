/*
================================================================================
檔案代號:bed_file
檔案名稱:E-BOM 取代/替代产品结构明细资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table bed_file
(
bed01       varchar2(40) NOT NULL,   /*主件料件编号                           */
                                     /*主件料件編號                           */
bed011      varchar2(10) NOT NULL,   /*版本                                   */
bed012      number(5) NOT NULL,      /*项次                                   */
                                     /*項次                                   */
bed02       varchar2(1) NOT NULL,    /*档案类型                               */
                                     /*檔案類別                               */
                                     /*儲存資料為取代或替代的資料型態。       */
                                     /*正確值為「1/2」。                      */
                                     /*1: UTE use to exhaust 取代資料         */
                                     /*2: SUB substitue      替代資料         */
bed03       number(5) NOT NULL,      /*替代序号                               */
                                     /*替代序號                               */
                                     /*儲存指定的替代順序。                   */
                                     /*如儲存的資料型態為替代資料時，方才有效。*/
bed04       varchar2(40),            /*取代替代料件编号                       */
                                     /*取代替代料件編號                       */
                                     /*儲存作為取代或替代的料件編號。         */
                                     /*料件編號需在料件基本資料主檔中。       */
bed05       date,                    /*生效日期                               */
                                     /*儲存指定的取代/替代生效日期。          */
                                     /*如儲存的資料型態為替代資料時，可自行維 */
                                     /*護；如儲存的資料型態為取代資料時，物料 */
                                     /*需求模擬時，系統自動規劃。             */
bed06       date,                    /*失效日期                               */
                                     /*儲存指定的取代/替代失效日期。          */
                                     /*如儲存的資料型態為替代資料時，可自行維 */
                                     /*護；如儲存的資料型態為取代資料時，不使 */
                                     /*用此失效日期。                         */
bed07       number(15,3),            /*取代替代量                             */
                                     /*儲存取代/替代的對應數量。              */
                                     /*數量單位同原始料件的發料單位。         */
bed09       date                     /*实际取代日/最近替代日                  */
                                     /*實際取代日/最近替代日                  */
                                     /*於工單發料作業過帳時自動更新           */
);

create        index bed_02 on bed_file (bed04);
alter table bed_file add  constraint bed_pk primary key  (bed01,bed011,bed012,bed02,bed03) enable validate;
grant select on bed_file to tiptopgp;
grant update on bed_file to tiptopgp;
grant delete on bed_file to tiptopgp;
grant insert on bed_file to tiptopgp;
grant index on bed_file to public;
grant select on bed_file to ods;
