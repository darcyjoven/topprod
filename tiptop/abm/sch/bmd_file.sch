/*
================================================================================
檔案代號:bmd_file
檔案名稱:取代/替代产品结构明细资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table bmd_file
(
bmd01       varchar2(40) NOT NULL,   /*原始料件编号                           */
                                     /*原始料件編號                           */
                                     /*儲存可作取代或替代的原始料件編號。     */
                                     /*原始料件編號需在料件基本資料主檔中。   */
bmd02       varchar2(1) NOT NULL,    /*档案类型                               */
                                     /*檔案類別                               */
                                     /*儲存資料為取代或替代的資料型態。       */
                                     /*正確值為「1/2」。                      */
                                     /*1: UTE use to exhaust 取代資料         */
                                     /*2: SUB substitue      替代資料         */
bmd03       number(5) NOT NULL,      /*替代序号                               */
                                     /*替代序號                               */
                                     /*儲存指定的替代順序。                   */
                                     /*如儲存的資料型態為替代資料時，方才有效。*/
bmd04       varchar2(40),            /*取代替代料件编号                       */
                                     /*取代替代料件編號                       */
                                     /*儲存作為取代或替代的料件編號。         */
                                     /*料件編號需在料件基本資料主檔中。       */
bmd05       date,                    /*生效日期                               */
                                     /*儲存指定的取代/替代生效日期。          */
                                     /*如儲存的資料型態為替代資料時，可自行維 */
                                     /*護；如儲存的資料型態為取代資料時，物料 */
                                     /*需求模擬時，系統自動規劃。             */
bmd06       date,                    /*失效日期                               */
                                     /*儲存指定的取代/替代失效日期。          */
                                     /*如儲存的資料型態為替代資料時，可自行維 */
                                     /*護；如儲存的資料型態為取代資料時，不使 */
                                     /*用此失效日期。                         */
bmd07       number(15,3),            /*取代替代量                             */
                                     /*儲存取代/替代的對應數量。              */
                                     /*數量單位同原始料件的發料單位。         */
bmd08       varchar2(40) NOT NULL,   /*主件编号                               */
                                     /*主件編號 (ALL 表示全部主件)            */
bmd09       date,                    /*实际取代日/最近替代日                  */
                                     /*實際取代日/最近替代日                  */
                                     /*於工單發料作業過帳時自動更新           */
bmdacti     varchar2(1),             /*资料有效码                             */
bmddate     date,                    /*最近更改日                             */
bmdgrup     varchar2(10),            /*资料所有部门                           */
bmduser     varchar2(10),            /*资料所有者                             */
bmdmodu     varchar2(10),            /*资料更改者                             */
bmdorig     varchar2(10),            /*资料建立部门                           */
bmdoriu     varchar2(10),            /*资料建立者                             */
bmd10       number(16,8),            /*底数                                   */
bmd11       varchar2(1) DEFAULT ' ' NOT NULL, /*回扣料*/
ta_bmd01    varchar2(20),
ta_bmd02    varchar2(20),
ta_bmd03    varchar2(20),
ta_bmd04    varchar2(20),
ta_bmd05    number(15,6),
ta_bmd06    number(15,6),
ta_bmd07    number(15,6),
ta_bmd08    number(15,6),
ta_bmd09    date,
ta_bmd10    date
);

create        index bmd_02 on bmd_file (bmd04);
create        index bmd_03 on bmd_file (bmd08);
alter table bmd_file add  constraint bmd_pk primary key  (bmd01,bmd08,bmd02,bmd03) enable validate;
grant select on bmd_file to tiptopgp;
grant update on bmd_file to tiptopgp;
grant delete on bmd_file to tiptopgp;
grant insert on bmd_file to tiptopgp;
grant index on bmd_file to public;
grant select on bmd_file to ods;
