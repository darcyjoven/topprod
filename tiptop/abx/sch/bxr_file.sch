/*
================================================================================
檔案代號:bxr_file
檔案名稱:保税异动原因编号档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table bxr_file
(
bxr01       varchar2(10) NOT NULL,   /*保税异动原因编号                       */
bxr02       varchar2(80),            /*说明                                   */
bxr03       number(5),               /*性质                                   */
                                     /*性質(No use)                           */
bxr04       number(5),               /*库存加减方式                           */
                                     /*庫存加減方式  (1/-1)                   */
bxr11       number(5),               /*保税进口数                             */
                                     /*保稅進口數    (1/-1)                   */
bxr12       number(5),               /*视同出口数                             */
                                     /*視同進口數    (1/-1)                   */
bxr13       number(5),               /*非保进口数                             */
                                     /*非保進口數    (1/-1)                   */
bxr21       number(5),               /*厂内生产领用数                         */
                                     /*廠內生產領用數(1/-1)                   */
bxr22       number(5),               /*委外生产领用数                         */
                                     /*廠外生產領用數(1/-1)                   */
bxr23       number(5),               /*外运数                                 */
                                     /*外運數        (1/-1)                   */
bxr24       number(5),               /*其他领用数                             */
                                     /*其他領用數    (1/-1)                   */
bxr25       number(5),               /*原料内销数                             */
                                     /*原料內銷數    (1/-1)                   */
bxr26       number(5),               /*原料外销数                             */
                                     /*原料外銷數    (1/-1)                   */
bxr31       number(5),               /*生产退料数                             */
                                     /*生產退料數    (1/-1)                   */
bxr41       number(5),               /*核准报废数                             */
                                     /*核准報廢數    (1/-1)                   */
bxr42       number(5),               /*调  整  数                             */
                                     /*調  整  數    (1/-1)                   */
bxr51       number(5),               /*成品存仓数                             */
                                     /*成品存倉數    (1/-1)                   */
bxr60       number(5),               /*成品出仓数                             */
                                     /*成品出倉數    (1/-1)                   */
bxr61       number(5),               /*直接出口数                             */
                                     /*直接出口數    (1/-1)                   */
bxr62       number(5),               /*视同出口数                             */
                                     /*視同出口數    (1/-1)                   */
bxr63       number(5),               /*内  销  数                             */
                                     /*內  銷  數    (1/-1)                   */
bxr64       number(5),               /*其它出仓数                             */
                                     /*其它出倉數    (1/-1)                   */
bxr91       varchar2(1),             /*是否须录入报单号码                     */
                                     /*Y/N                                    */
bxr92       varchar2(1),             /*是否须录入厂内编号                     */
                                     /*Y/N                                    */
bxr93       varchar2(1),             /*是否须录入放行单号                     */
                                     /*Y/N                                    */
bxr94       varchar2(1),             /*是否须录入报单日期                     */
                                     /*Y/N                                    */
bxr95       varchar2(1),             /*是否须录入金额                         */
                                     /*Y/N                                    */
bxr96       varchar2(1),             /*No Use                                 */
bxr97       varchar2(1),             /*No Use                                 */
bxr98       varchar2(1),             /*No Use                                 */
bxr99       varchar2(1)              /*No Use                                 */
);

alter table bxr_file add  constraint bxr_pk primary key  (bxr01) enable validate;
grant select on bxr_file to tiptopgp;
grant update on bxr_file to tiptopgp;
grant delete on bxr_file to tiptopgp;
grant insert on bxr_file to tiptopgp;
grant index on bxr_file to public;
grant select on bxr_file to ods;
