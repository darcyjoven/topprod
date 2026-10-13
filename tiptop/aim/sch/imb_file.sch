/*
================================================================================
檔案代號:imb_file
檔案名稱:料件成本要素资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table imb_file
(
imb01       varchar2(40) NOT NULL,   /*料件编号                               */
                                     /*料件編號ima01                          */
                                     /*需存在 料件資料主檔 中                 */
imb02       varchar2(1),             /*标准成本资料取得方式                   */
                                     /*標準成本資料取得方式                   */
                                     /*儲存該料件中標準成本取得的方式。       */
                                     /*正確值為 '0' or '1' or '2' or '3'      */
                                     /*0: 人為直接輸入                        */
                                     /*1: 現時成本轉成                        */
                                     /*2: 預設成本轉成                        */
                                     /*3: 其它                                */
imb111      number(20,6) NOT NULL,   /*标准本阶材料成本                       */
                                     /*標準本階材料成本                       */
imb112      number(20,6) NOT NULL,   /*标准本阶材料制造费用                   */
                                     /*標準本階材料製造費用(間接材料)         */
imb1131     number(20,6) NOT NULL,   /*标准本阶人工成本                       */
                                     /*標準本階人工成本                       */
imb1132     number(20,6) NOT NULL,   /*标准本阶人工制造费用                   */
                                     /*標準本階人工製造費用(間接人工)         */
imb114      number(20,6) NOT NULL,   /*标准本阶固定制造费用成本               */
                                     /*標準本階固定製造費用成本               */
imb115      number(20,6) NOT NULL,   /*标准本阶变动制造费用成本               */
                                     /*標準本階變動製造費用成本               */
imb1151     number(20,6) NOT NULL,   /*标准本阶委外加工材料成本               */
                                     /*標準本階廠外加工材料成本               */
imb116      number(20,6) NOT NULL,   /*标准本阶委外加工成本                   */
                                     /*標準本階廠外加工成本                   */
imb1171     number(20,6) NOT NULL,   /*标准本阶委外加工固定制造费             */
                                     /*標準本階廠外加工固定製造費用成本       */
imb1172     number(20,6) NOT NULL,   /*标准本阶委外加工变动制造费             */
                                     /*標準本階廠外加工變動製造費用成本       */
imb119      number(20,6) NOT NULL,   /*标准本阶机器成本                       */
                                     /*標準本階機器成本                       */
imb118      number(20,6) NOT NULL,   /*标准采购成本                           */
                                     /*標準採購成本                           */
imb120      number(20,6) NOT NULL,   /*标准本阶附加成本                       */
                                     /*標準本階附加成本                       */
imb121      number(20,6) NOT NULL,   /*标准下阶材料成本                       */
                                     /*標準下階材料成本                       */
imb122      number(20,6) NOT NULL,   /*标准下阶材料制造费用成本               */
                                     /*標準下階材料製造費用成本(間接材料)     */
imb1231     number(20,6) NOT NULL,   /*标准下阶人工成本                       */
                                     /*標準下階人工成本                       */
imb1232     number(20,6) NOT NULL,   /*标准下阶人工制造费用成本               */
                                     /*標準下階人工製造費用成本(間接人工)     */
imb124      number(20,6) NOT NULL,   /*标准下阶固定制造成本                   */
                                     /*標準下階固定製造成本                   */
imb125      number(20,6) NOT NULL,   /*标准下阶变动制造成本                   */
                                     /*標準下階變動製造成本                   */
imb1251     number(20,6) NOT NULL,   /*标准本阶委外加工材料成本               */
                                     /*標準本階廠外加工材料成本               */
imb126      number(20,6) NOT NULL,   /*标准下阶委外加工成本                   */
                                     /*標準下階廠外加工成本                   */
imb1271     number(20,6) NOT NULL,   /*标准下阶委外加工固定制造费             */
                                     /*標準下階廠外加工固定製造費用成本       */
imb1272     number(20,6) NOT NULL,   /*标准下阶委外加工变动制造费             */
                                     /*標準下階廠外加工變動製造費用成本       */
imb129      number(20,6) NOT NULL,   /*标准下阶机器成本                       */
                                     /*標準下階機器成本                       */
imb130      number(20,6) NOT NULL,   /*标准下阶附加成本                       */
                                     /*標準下階附加成本                       */
imb211      number(20,6) NOT NULL,   /*现时本阶材料成本                       */
                                     /*現時本階材料成本                       */
imb212      number(20,6) NOT NULL,   /*现时本阶材料制造费用                   */
                                     /*現時本階材料製造費用(間接材料)         */
imb2131     number(20,6) NOT NULL,   /*现时本阶人工成本                       */
                                     /*現時本階人工成本                       */
imb2132     number(20,6) NOT NULL,   /*现时本阶人工制造费用                   */
                                     /*現時本階人工製造費用(間接人工)         */
imb214      number(20,6) NOT NULL,   /*现时本阶固定制造费用成本               */
                                     /*現時本階固定製造費用成本               */
imb215      number(20,6) NOT NULL,   /*现时本阶变动制造费用成本               */
                                     /*現時本階變動製造費用成本               */
imb2151     number(20,6) NOT NULL,   /*现时本阶委外加工材料成本               */
                                     /*現時本階廠外加工材料成本               */
imb216      number(20,6) NOT NULL,   /*现时本阶委外人工成本                   */
                                     /*現時本階廠外人工成本                   */
imb2171     number(20,6) NOT NULL,   /*现时本阶委外加工固定制造费             */
                                     /*現時本階廠外加工固定製造費用成本       */
imb2172     number(20,6) NOT NULL,   /*现时本阶委外加工变动制造费             */
                                     /*現時本階廠外加工變動製造費用成本       */
imb219      number(20,6) NOT NULL,   /*现时本阶机器成本                       */
                                     /*現時本階機器成本                       */
imb218      number(20,6) NOT NULL,   /*现时采购成本                           */
                                     /*現時採購成本                           */
imb220      number(20,6) NOT NULL,   /*现时本阶附加成本                       */
                                     /*現時本階附加成本                       */
imb221      number(20,6) NOT NULL,   /*现时下阶材料成本                       */
                                     /*現時下階材料成本                       */
imb222      number(20,6) NOT NULL,   /*现时下阶材料制造费用成本               */
                                     /*現時下階材料製造費用成本(間接材料)     */
imb2231     number(20,6) NOT NULL,   /*现时下阶人工成本                       */
                                     /*現時下階人工成本                       */
imb2232     number(20,6) NOT NULL,   /*现时下阶人工制造费用成本               */
                                     /*現時下階人工製造費用成本(間接人工)     */
imb224      number(20,6) NOT NULL,   /*现时下阶固定制造成本                   */
                                     /*現時下階固定製造成本                   */
imb225      number(20,6) NOT NULL,   /*现时下阶变动制造成本                   */
                                     /*現時下階變動製造成本                   */
imb2251     number(20,6) NOT NULL,   /*现时下阶委外加工材料成本               */
                                     /*現時下階廠外加工材料成本               */
imb226      number(20,6) NOT NULL,   /*现时下阶委外加工成本                   */
                                     /*現時下階廠外加工成本                   */
imb2271     number(20,6) NOT NULL,   /*现时下阶委外加工固定制造费             */
                                     /*現時下階廠外加工固定製造費用成本       */
imb2272     number(20,6) NOT NULL,   /*现时下阶委外加工变动制造费             */
                                     /*現時下階廠外加工變動製造費用成本       */
imb229      number(20,6) NOT NULL,   /*现时下阶机器成本                       */
                                     /*現時下階機器成本                       */
imb230      number(20,6) NOT NULL,   /*现时下阶附加成本                       */
                                     /*現時下階附加成本                       */
imb311      number(20,6) NOT NULL,   /*缺省本阶材料成本                       */
                                     /*預設本階材料成本                       */
imb312      number(20,6) NOT NULL,   /*缺省本阶材料制造费用                   */
                                     /*預設本階材料製造費用(間接材料)         */
imb3131     number(20,6) NOT NULL,   /*缺省本阶人工成本                       */
                                     /*預設本階人工成本                       */
imb3132     number(20,6) NOT NULL,   /*缺省本阶人工制造费用                   */
                                     /*預設本階人工製造費用(間接人工)         */
imb314      number(20,6) NOT NULL,   /*缺省本阶固定制造费用成本               */
                                     /*預設本階固定製造費用成本               */
imb315      number(20,6) NOT NULL,   /*缺省本阶变动制造费用成本               */
                                     /*預設本階變動製造費用成本               */
imb3151     number(20,6) NOT NULL,   /*缺省本阶委外加工材料成本               */
                                     /*預設本階廠外加工材料成本               */
imb316      number(20,6) NOT NULL,   /*缺省本阶委外加工成本                   */
                                     /*預設本階廠外加工成本                   */
imb3171     number(20,6) NOT NULL,   /*缺省本阶委外加工固定制造费             */
                                     /*預設本階廠外加工固定製造費用成本       */
imb3172     number(20,6) NOT NULL,   /*缺省本阶委外加工变动制造费             */
                                     /*預設本階廠外加工變動製造費用成本       */
imb319      number(20,6) NOT NULL,   /*缺省本阶机器成本                       */
                                     /*預設本階機器成本                       */
imb318      number(20,6) NOT NULL,   /*缺省采购成本                           */
                                     /*預設採購成本                           */
imb320      number(20,6) NOT NULL,   /*缺省本阶附加成本                       */
                                     /*預設本階附加成本                       */
imb321      number(20,6) NOT NULL,   /*缺省下阶材料成本                       */
                                     /*預設下階材料成本                       */
imb322      number(20,6) NOT NULL,   /*缺省下阶材料制造费用成本               */
                                     /*預設下階材料製造費用成本(間接材料)     */
imb3231     number(20,6) NOT NULL,   /*缺省下阶人工成本                       */
                                     /*預設下階人工成本                       */
imb3232     number(20,6) NOT NULL,   /*缺省下阶人工制造费用成本               */
                                     /*預設下階人工製造費用成本(間接人工)     */
imb324      number(20,6) NOT NULL,   /*缺省下阶固定制造成本                   */
                                     /*預設下階固定製造成本                   */
imb325      number(20,6) NOT NULL,   /*缺省下阶变动制造成本                   */
                                     /*預設下階變動製造成本                   */
imb3251     number(20,6) NOT NULL,   /*缺省下阶委外加工材料成本               */
                                     /*預設下階廠外加工材料成本               */
imb326      number(20,6) NOT NULL,   /*缺省下阶委外加工成本                   */
                                     /*預設下階廠外加工成本                   */
imb3271     number(20,6) NOT NULL,   /*缺省下阶委外加工固定制造费             */
                                     /*預設下階廠外加工固定製造費用成本       */
imb3272     number(20,6) NOT NULL,   /*缺省下阶委外加工变动制造费             */
                                     /*預設下階廠外加工變動製造費用成本       */
imb329      number(20,6) NOT NULL,   /*缺省下阶机器成本                       */
                                     /*預設下階機器成本                       */
imb330      number(20,6) NOT NULL,   /*缺省下阶附加成本                       */
                                     /*預設下階附加成本                       */
imbacti     varchar2(1),             /*资料有效码                             */
                                     /*資料有效碼                             */
                                     /*系統維護。                             */
imbuser     varchar2(10),            /*资料所有者                             */
                                     /*資料所有者                             */
                                     /*系統維護。                             */
imbgrup     varchar2(10),            /*资料所有群                             */
                                     /*資料所有群                             */
                                     /*系統維護。                             */
imbmodu     varchar2(10),            /*资料更改者                             */
                                     /*資料更改者                             */
                                     /*系統維護。                             */
imbdate     date,                    /*最近更改日                             */
                                     /*最近修改日                             */
                                     /*系統維護。                             */
imboriu     varchar2(10),            /*资料建立者                             */
imborig     varchar2(10)             /*资料建立部门                           */
);

alter table imb_file add  constraint imb_pk primary key  (imb01) enable validate;
grant select on imb_file to tiptopgp;
grant update on imb_file to tiptopgp;
grant delete on imb_file to tiptopgp;
grant insert on imb_file to tiptopgp;
grant index on imb_file to public;
grant select on imb_file to ods;
