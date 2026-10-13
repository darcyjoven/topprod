/*
================================================================================
檔案代號:oed_file
檔案名稱:订单单头档--for多角贸易相关资料
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table oed_file
(
oed01       varchar2(20) NOT NULL,   /*订单单号                               */
                                     /*訂單單號 oea01                         */
oed021      varchar2(80),            /*Forwarder - 说明一                     */
                                     /*Forwarder - 說明一                     */
oed022      varchar2(80),            /*Forwarder - 说明二                     */
                                     /*Forwarder - 說明二                     */
oed023      varchar2(80),            /*Forwarder - 说明三                     */
                                     /*Forwarder - 說明三                     */
oed03       varchar2(2),             /*Consignee - 类型                       */
                                     /*Consignee - 類別                       */
oed030      number(5),               /*Consignee - 序号                       */
                                     /*Consignee - 序號                       */
oed031      varchar2(255),           /*Consignee - 说明一                     */
                                     /*Consignee - 說明一                     */
oed032      varchar2(80),            /*Consignee - 说明二                     */
                                     /*Consignee - 說明二                     */
oed033      varchar2(80),            /*Consignee - 说明三                     */
                                     /*Consignee - 說明三                     */
oed034      varchar2(80),            /*Consignee - 说明四                     */
                                     /*Consignee - 說明四                     */
oed04       varchar2(2),             /*Notify - 类型                          */
                                     /*Notify - 類別                          */
oed040      number(5),               /*Notify - 序号                          */
                                     /*Notify - 序號                          */
oed041      varchar2(80),            /*Notify - 说明一                        */
                                     /*Notify - 說明一                        */
oed042      varchar2(255),           /*Notify - 说明二                        */
                                     /*Notify - 說明二                        */
oed043      varchar2(80),            /*Notify - 说明三                        */
                                     /*Notify - 說明三                        */
oed044      varchar2(80),            /*Notify - 说明四                        */
                                     /*Notify - 說明四                        */
oed05       varchar2(2),             /*Remark - 类型                          */
                                     /*Remark - 類別                          */
oed050      number(5),               /*Remark - 序号                          */
                                     /*Remark - 序號                          */
oed051      varchar2(80),            /*Remark - 说明一                        */
                                     /*Remark - 說明一                        */
oed052      varchar2(80),            /*Remark - 说明二                        */
                                     /*Remark - 說明二                        */
oed053      varchar2(80),            /*Remark - 说明三                        */
                                     /*Remark - 說明三                        */
oed054      varchar2(80),            /*Remark - 说明四                        */
                                     /*Remark - 說明四                        */
oed055      varchar2(80),            /*Remark - 说明五                        */
                                     /*Remark - 說明五                        */
oed056      varchar2(80),            /*Remark - 说明六                        */
                                     /*Remark - 說明六                        */
oed057      varchar2(80),            /*Remark - 说明七                        */
                                     /*Remark - 說明七                        */
oed058      varchar2(80),            /*Remark - 说明八                        */
                                     /*Remark - 說明八                        */
oed06       varchar2(2),             /*Shipping Mark - 类型                   */
                                     /*Shipping Mark - 類別                   */
oed060      number(5),               /*Shipping Mark - 序号                   */
                                     /*Shipping Mark - 序號                   */
oed061      varchar2(80),            /*Shipping Mark - 说明一                 */
                                     /*Shipping Mark - 說明一                 */
oed062      varchar2(80),            /*Shipping Mark - 说明二                 */
                                     /*Shipping Mark - 說明二                 */
oed063      varchar2(80),            /*Shipping Mark - 说明三                 */
                                     /*Shipping Mark - 說明三                 */
oed064      varchar2(80),            /*Shipping Mark - 说明四                 */
                                     /*Shipping Mark - 說明四                 */
oed065      varchar2(80),            /*Shipping Mark - 说明五                 */
                                     /*Shipping Mark - 說明五                 */
oed066      varchar2(80),            /*Shipping Mark - 说明六                 */
                                     /*Shipping Mark - 說明六                 */
oed067      varchar2(80),            /*Shipping Mark - 说明七                 */
                                     /*Shipping Mark - 說明七                 */
oed068      varchar2(80),            /*Shipping Mark - 说明八                 */
                                     /*Shipping Mark - 說明八                 */
oed07       varchar2(36),            /*No Use                                 */
oed08       varchar2(36),            /*No Use                                 */
oed09       varchar2(36),            /*No Use                                 */
oed10       varchar2(36),            /*No Use                                 */
oedplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
oedlegal    varchar2(10) NOT NULL    /*所属法人                               */
);

alter table oed_file add  constraint oed_pk primary key  (oed01) enable validate;
grant select on oed_file to tiptopgp;
grant update on oed_file to tiptopgp;
grant delete on oed_file to tiptopgp;
grant insert on oed_file to tiptopgp;
grant index on oed_file to public;
grant select on oed_file to ods;
