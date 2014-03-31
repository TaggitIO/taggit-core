require "spec_helper"

describe Api::ReleasesController do
  let(:owner) { Owner.create(github_id: 1234, login: "foo") }
  let(:repo)  { Repo.create(github_id: 1, name: "bar", full_name: "foo/bar", owner_id: owner.id) }

  before do
    10.times do |i|
      Release.create(repo_id: repo.id, github_id: i)
    end
  end

  describe "#index" do
    it "renders a JSON list of the six most recent releases" do
      get :index

      resp = json["releases"]
      expect(resp.count).to eq 6
    end

    it "sideloads repo data for each release" do
      get :index
      resp = json["repos"]
      expect(resp.count).to eq 1
    end
  end
end
