/*
================================================================================
檔案代號:caf_file
檔案名稱:在制月结档
檔案目的:
上游檔案:
下游檔案:
檔案類型:S
多語系檔案:N
============.========================.==========================================
*/
create table caf_file
(
caf01       varchar2(20) NOT NULL,   /*工单编号                               */
                                     /*工單編號                               */
caf02       number(5) NOT NULL,      /*年度                                   */
caf03       number(5) NOT NULL,      /*月份                                   */
caf04       varchar2(40),            /*料件编号                               */
                                     /*料件編號                               */
                                     /*需存在在料件基本資料主檔               */
                                     /*為該工單生產料件編號                   */
caf05       number(5) NOT NULL,      /*工艺序号                               */
                                     /*製程序號                               */
                                     /*料件被製作程序過程中的生產活動順序編號 */
caf06       varchar2(6) NOT NULL,    /*作业编号                               */
                                     /*作業編號                               */
                                     /*料件被製作程序過程中的生產活動編號     */
caf07       varchar2(10),            /*工作中心编号                           */
                                     /*工作中心編號                           */
                                     /*該生產程序/作業在何一工作站被生產      */
caf10       number(15,3),            /*盘点量                                 */
                                     /*盤點量                                 */
caf11       number(15,3),            /*返工转入量       (+)                   */
                                     /*重工轉入量       (+)                   */
caf12       number(15,3),            /*工单转入量       (+)                   */
                                     /*工單轉入量       (+)                   */
caf13       number(15,3),            /*良品转出量       (-)                   */
                                     /*良品轉出量       (-)                   */
caf14       number(15,3),            /*Bonus Qty        (-)                   */
caf15       number(15,3),            /*返工转出         (-)                   */
                                     /*重工轉出         (-)                   */
caf16       number(15,3),            /*当站报废量       (-)                   */
                                     /*當站報廢量       (-)                   */
caf17       number(15,3),            /*当站下线量(入库) (-)                   */
caf18       number(15,3),            /*工单转出量       (-)                   */
                                     /*工單轉出量       (-)                   */
caf19       number(15,3),            /*委外完工量                             */
cafdate     date,                    /*工艺首次完工日                         */
                                     /*製程首次完工日                         */
caftime     number(10),              /*工艺最后报工时间                       */
caflegal    varchar2(10) NOT NULL,   /*所属法人                               */
caf012      varchar2(10) DEFAULT ' ' NOT NULL /*工艺段号*/
);

alter table caf_file add  constraint caf_pk primary key  (caf01,caf02,caf03,caf05,caf06,caf012) enable validate;
grant select on caf_file to tiptopgp;
grant update on caf_file to tiptopgp;
grant delete on caf_file to tiptopgp;
grant insert on caf_file to tiptopgp;
grant index on caf_file to public;
grant select on caf_file to ods;
