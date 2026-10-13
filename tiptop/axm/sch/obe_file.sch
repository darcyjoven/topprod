/*
================================================================================
檔案代號:obe_file
檔案名稱:包装方式档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table obe_file
(
obe01       varchar2(15) NOT NULL,   /*包装方式编号                           */
                                     /*包裝方式編號                           */
obe02       varchar2(80),            /*包装说明                               */
                                     /*包裝說明                               */
obe11       varchar2(4),             /*内包装单位                             */
                                     /*內包裝單位                             */
obe12       number(15,3),            /*内包装含产品数量                       */
                                     /*內包裝含產品數量                       */
obe13       number(15,3),            /*内包装重量(Kg)                         */
                                     /*內包裝重量(Kg)                         */
obe21       varchar2(4),             /*外包装单位                             */
                                     /*外包裝單位                             */
obe22       number(5),               /*外包装含内包装数量                     */
                                     /*外包裝含內包裝數量                     */
obe23       number(15,3),            /*外包装重量(Kg)                         */
                                     /*外包裝重量(Kg)                         */
obe24       number(15,3),            /*外包装含产品数量                       */
                                     /*外包裝含產品數量(=obe12*obe22)         */
obe251      number(15,3),            /*外包装尺寸-长(ft)                      */
                                     /*外包裝尺寸-長(ft)                      */
obe252      number(15,3),            /*外包装尺寸-宽(ft)                      */
                                     /*外包裝尺寸-寬(ft)                      */
obe253      number(15,3),            /*外包装尺寸-高(ft)                      */
                                     /*外包裝尺寸-高(ft)                      */
obe26       number(15,3),            /*外包装容积(Cuft)                       */
                                     /*外包裝容積(Cuft)                       */
obe28       varchar2(15),            /*外包装条码编号                         */
                                     /*外包裝條碼編號                         */
obe291      number(15,3),            /*内包装长度                             */
obe292      number(15,3),            /*内包装宽度                             */
obe293      number(15,3),            /*内包装高度                             */
obe30       number(15,3)             /*内包装容积                             */
);

alter table obe_file add  constraint obe_pk primary key  (obe01) enable validate;
grant select on obe_file to tiptopgp;
grant update on obe_file to tiptopgp;
grant delete on obe_file to tiptopgp;
grant insert on obe_file to tiptopgp;
grant index on obe_file to public;
grant select on obe_file to ods;
