import scrapy
import json

class VisitNswScrapingSpider(scrapy.Spider):
    name = 'visit_nsw_bot'
    allowed_domains = ['visitnsw.com']
    start_urls = ['https://www.visitnsw.com/things-to-do/attractions']
    headers = {
    "Accept": "*/*",
    "Accept-Encoding": "gzip, deflate, br",
    "Accept-Language": "en,en-AU;q=0.9",
    "Referer": "https://www.visitnsw.com/things-to-do/attractions",
    "Sec-Fetch-Mode": "cors",
    "Sec-Fetch-Site": "same-origin",
    "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/90.0.4430.212 Safari/537.36",
    }
    custom_settings = {'FEED_URI': 'destinations.json',
                        'FEED_FORMAT': 'json',
                       }

    def parse(self, response):
        url = "https://www.visitnsw.com/things-to-do/attractions"

        request = scrapy.Request(url,
            callback = self.parse_api,
            headers = self.headers)
        yield request

    def parse_api(self, response):
        base_url = "https://www.visitnsw.com/api/product-list-data/22001?_format=hal_json&exclude_promoted=false&field_product_reference_target_id[]=171&items_per_page=30&page="
        page = 0

        for k in range(140):
            page_url = base_url + str(page)
            request = scrapy.Request(page_url,
                callback = self.parse_page,
                headers = self.headers)
            page += 1
            yield request

    def parse_page(self, response):
        raw_data = response.body
        raw_data1 = json.loads(raw_data)
        data = raw_data1["results"]

        scraped_info = []
        for destination in data:
            if len(destination['url'].split("/")) == 7:
                dict = {}
                dict['name'] = destination['title']
                dict['coordinates'] = destination['field_geo_physical_address']
                dict['x_coordinates'] = destination['field_geo_physical_address'].split(",")[0]
                dict['y_coordinates'] = destination['field_geo_physical_address'].split(",")[1]
                dict['region'] = destination['url'].split("/")[2]
                dict['area'] = destination['url'].split("/")[3]
                dict['locality'] = destination['url'].split("/")[4]
                dict['type'] = []
                for num,element in enumerate(destination['classifications'],1):
                    dict1 = {}
                    dict1['id'] = str(num)
                    dict1['destination_type'] = element['name']
                    dict['type'].append(dict1)
                scraped_info.append(dict)
            else:
                dict = {}
                dict['name'] = destination['title']
                dict['coordinates'] = destination['field_geo_physical_address']
                dict['x_coordinates'] = destination['field_geo_physical_address'].split(",")[0]
                dict['y_coordinates'] = destination['field_geo_physical_address'].split(",")[1]
                dict['region'] = destination['url'].split("/")[2]
                dict['area'] = destination['url'].split("/")[3]
                dict['type'] = []
                for num,element in enumerate(destination['classifications'],1):
                    dict1 = {}
                    dict1['id'] = str(num)
                    dict1['destination_type'] = element['name']
                    dict['type'].append(dict1)
                scraped_info.append(dict)
        for item in scraped_info:
            yield item